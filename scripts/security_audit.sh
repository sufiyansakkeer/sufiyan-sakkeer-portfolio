#!/bin/bash

# Security audit script for Flutter project
# This script checks for exposed API keys and sensitive data

echo "🔍 Security Audit Report"
echo "========================"
echo ""

# Check if .env file exists and is not tracked
echo "📁 Environment File Status:"
if [ -f ".env" ]; then
    echo "✅ .env file exists"
    if git ls-files --error-unmatch .env 2>/dev/null; then
        echo "❌ WARNING: .env file is tracked by git!"
    else
        echo "✅ .env file is properly ignored by git"
    fi
else
    echo "⚠️  .env file not found (create from .env.example)"
fi
echo ""

# Check .gitignore patterns
echo "🚫 .gitignore Security Patterns:"
if grep -q "firebase_options.dart" .gitignore; then
    echo "✅ firebase_options.dart pattern found"
else
    echo "❌ firebase_options.dart pattern missing"
fi

if grep -q "\.env" .gitignore; then
    echo "✅ .env pattern found"
else
    echo "❌ .env pattern missing"
fi

if grep -q "google-services.json" .gitignore; then
    echo "✅ google-services.json pattern found"
else
    echo "❌ google-services.json pattern missing"
fi
echo ""

# Check for hardcoded API keys
echo "🔑 Hardcoded API Key Check:"
api_key_files=$(grep -r "AIzaSy" . --exclude-dir=.git --exclude="*.md" --exclude="*.sh" --exclude-dir=scripts --exclude=".env.example" 2>/dev/null | wc -l)
if [ "$api_key_files" -gt 0 ]; then
    echo "❌ Found $api_key_files files with hardcoded API keys:"
    grep -r "AIzaSy" . --exclude-dir=.git --exclude="*.md" --exclude="*.sh" --exclude-dir=scripts --exclude=".env.example" 2>/dev/null | cut -d: -f1 | sort | uniq
    echo ""
    echo "🚨 CRITICAL: These files contain exposed API keys!"
    echo "   Action required: Rotate API keys and update code"
else
    echo "✅ No hardcoded API keys found"
fi
echo ""

# Check for other sensitive patterns
echo "🔒 Other Sensitive Data Check:"
sensitive_patterns=("password" "secret" "token" "credential" "private.*key")
found_sensitive=false

for pattern in "${sensitive_patterns[@]}"; do
    matches=$(grep -ri "$pattern" . --exclude-dir=.git --exclude="*.md" --exclude="*.sh" --exclude-dir=scripts --exclude=".env.example" 2>/dev/null | grep -v "// " | grep -v "# " | wc -l)
    if [ "$matches" -gt 0 ]; then
        echo "⚠️  Found potential sensitive data: $pattern"
        found_sensitive=true
    fi
done

if [ "$found_sensitive" = false ]; then
    echo "✅ No obvious sensitive patterns found"
fi
echo ""

# Check git tracking status of sensitive files
echo "📊 Git Tracking Status:"
sensitive_files=("lib/firebase_options.dart" "web/index.html" ".env")
for file in "${sensitive_files[@]}"; do
    if [ -f "$file" ]; then
        if git ls-files --error-unmatch "$file" 2>/dev/null; then
            echo "❌ $file is tracked by git"
        else
            echo "✅ $file is not tracked by git"
        fi
    else
        echo "ℹ️  $file does not exist"
    fi
done
echo ""

# Security recommendations
echo "📋 Security Recommendations:"
echo "1. ✅ Update .gitignore with security patterns (DONE)"
echo "2. ✅ Create secure configuration system (DONE)"
echo "3. ⚠️  Rotate exposed API keys (PENDING)"
echo "4. ⚠️  Update code to use secure configuration (PENDING)"
echo "5. ⚠️  Remove sensitive files from git tracking (PENDING)"
echo ""

echo "🎯 Next Steps:"
echo "1. Follow the API key rotation guide: scripts/rotate_api_keys.md"
echo "2. Update your code to use lib/config/firebase_config.dart"
echo "3. Create .env file from .env.example"
echo "4. Test your application with new configuration"
echo "5. Consider removing sensitive files from git history"
echo ""

echo "📚 Documentation:"
echo "- Security setup guide: SECURITY_SETUP.md"
echo "- API key rotation: scripts/rotate_api_keys.md"
echo "- Git history cleanup: scripts/clean_git_history.sh"
