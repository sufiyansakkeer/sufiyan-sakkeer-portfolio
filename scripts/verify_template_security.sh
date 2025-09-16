#!/bin/bash

# Security verification script for Flutter template
# This script verifies that no sensitive data is exposed in the template

echo "🔍 Template Security Verification"
echo "================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Track overall security status
SECURITY_ISSUES=0

# Function to print status
print_status() {
    if [ $2 -eq 0 ]; then
        echo -e "${GREEN}✅ $1${NC}"
    else
        echo -e "${RED}❌ $1${NC}"
        SECURITY_ISSUES=$((SECURITY_ISSUES + 1))
    fi
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check 1: No real API keys in source code
echo "🔑 Checking for exposed API keys..."
real_api_keys=$(grep -r "AIzaSy[A-Za-z0-9_-]\{35\}" . --exclude-dir=.git --exclude="*.md" --exclude="*.sh" --exclude-dir=scripts --exclude=".env.example" 2>/dev/null | grep -v "YOUR_.*_API_KEY" | wc -l)
print_status "No real API keys found in source code" $real_api_keys

if [ $real_api_keys -gt 0 ]; then
    echo "   Found potential real API keys in:"
    grep -r "AIzaSy[A-Za-z0-9_-]\{35\}" . --exclude-dir=.git --exclude="*.md" --exclude="*.sh" --exclude-dir=scripts --exclude=".env.example" 2>/dev/null | grep -v "YOUR_.*_API_KEY" | cut -d: -f1 | sort | uniq
fi
echo ""

# Check 2: Template placeholders are used
echo "🏷️  Checking for template placeholders..."
web_placeholder=$(grep -c "YOUR_WEB_API_KEY_HERE" lib/firebase_options.dart 2>/dev/null || echo 0)
android_placeholder=$(grep -c "YOUR_ANDROID_API_KEY_HERE" lib/firebase_options.dart 2>/dev/null || echo 0)
ios_placeholder=$(grep -c "YOUR_IOS_API_KEY_HERE" lib/firebase_options.dart 2>/dev/null || echo 0)

if [ $web_placeholder -gt 0 ] && [ $android_placeholder -gt 0 ] && [ $ios_placeholder -gt 0 ]; then
    print_status "Template placeholders properly used" 0
else
    print_status "Template placeholders missing or incorrect" 1
fi
echo ""

# Check 3: Environment variable usage
echo "🌍 Checking environment variable usage..."
env_usage=$(grep -c "_getEnvVar" lib/firebase_options.dart 2>/dev/null || echo 0)
if [ $env_usage -gt 0 ]; then
    print_status "Environment variables properly implemented" 0
else
    print_status "Environment variables not implemented" 1
fi
echo ""

# Check 4: .env file is not tracked
echo "📁 Checking .env file status..."
if [ -f ".env" ]; then
    if git ls-files --error-unmatch .env 2>/dev/null; then
        print_status ".env file is not tracked by git" 1
        print_warning "Remove .env from git tracking: git rm --cached .env"
    else
        print_status ".env file is not tracked by git" 0
    fi
else
    print_info ".env file does not exist (expected for template)"
fi
echo ""

# Check 5: .env.example exists and has placeholders
echo "📋 Checking .env.example template..."
if [ -f ".env.example" ]; then
    placeholder_count=$(grep -c "your-.*-here\|your-project-id\|YOUR_.*_HERE" .env.example 2>/dev/null || echo 0)
    if [ $placeholder_count -gt 5 ]; then
        print_status ".env.example has proper placeholders" 0
    else
        print_status ".env.example missing placeholders" 1
    fi
else
    print_status ".env.example file exists" 1
fi
echo ""

# Check 6: .gitignore patterns
echo "🚫 Checking .gitignore security patterns..."
gitignore_patterns=0

if grep -q "\.env$" .gitignore 2>/dev/null; then
    gitignore_patterns=$((gitignore_patterns + 1))
fi

if grep -q "firebase_options\.dart" .gitignore 2>/dev/null; then
    gitignore_patterns=$((gitignore_patterns + 1))
fi

if grep -q "google-services\.json" .gitignore 2>/dev/null; then
    gitignore_patterns=$((gitignore_patterns + 1))
fi

if [ $gitignore_patterns -ge 3 ]; then
    print_status ".gitignore has security patterns" 0
else
    print_status ".gitignore missing security patterns" 1
fi
echo ""

# Check 7: Web configuration security
echo "🌐 Checking web configuration..."
web_hardcoded=$(grep -c "AIzaSy" web/index.html 2>/dev/null)
if [ -z "$web_hardcoded" ]; then
    web_hardcoded=0
fi
if [ "$web_hardcoded" -eq 0 ]; then
    print_status "Web configuration is secure" 0
else
    print_status "Web configuration has hardcoded values" 1
fi
echo ""

# Check 8: Documentation exists
echo "📚 Checking documentation..."
docs_exist=0

if [ -f "FIREBASE_SETUP.md" ]; then
    docs_exist=$((docs_exist + 1))
fi

if [ -f "README_TEMPLATE.md" ]; then
    docs_exist=$((docs_exist + 1))
fi

if [ $docs_exist -ge 2 ]; then
    print_status "Setup documentation exists" 0
else
    print_status "Setup documentation missing" 1
fi
echo ""

# Check 9: No sensitive files in git history
echo "📜 Checking git history for sensitive files..."
sensitive_in_history=$(git log --name-only --pretty=format: | grep -E "(\.env$|google-services\.json|GoogleService-Info\.plist)" | wc -l 2>/dev/null || echo 0)
if [ $sensitive_in_history -eq 0 ]; then
    print_status "No sensitive files in git history" 0
else
    print_status "Sensitive files found in git history" 1
    print_warning "Consider cleaning git history or rotating keys"
fi
echo ""

# Final security assessment
echo "🎯 Security Assessment Summary"
echo "=============================="

if [ $SECURITY_ISSUES -eq 0 ]; then
    echo -e "${GREEN}🎉 EXCELLENT! Template is secure for public repositories${NC}"
    echo ""
    echo "✅ All security checks passed"
    echo "✅ No sensitive data exposed"
    echo "✅ Template ready for public use"
else
    echo -e "${RED}⚠️  SECURITY ISSUES FOUND: $SECURITY_ISSUES${NC}"
    echo ""
    echo "❌ Please fix the issues above before making repository public"
    echo "❌ Some sensitive data may still be exposed"
fi

echo ""
echo "📋 Next Steps for Template Users:"
echo "1. Copy .env.example to .env"
echo "2. Fill in your actual Firebase configuration"
echo "3. Test the application locally"
echo "4. Deploy with environment variables configured"
echo ""
echo "📚 Documentation:"
echo "- FIREBASE_SETUP.md - Detailed setup instructions"
echo "- README_TEMPLATE.md - Template usage guide"
echo ""

# Exit with error code if security issues found
exit $SECURITY_ISSUES
