#!/bin/bash

# Script to remove sensitive files from git history
# WARNING: This will rewrite git history and require force push

echo "🚨 WARNING: This script will rewrite git history!"
echo "Make sure you have a backup of your repository before proceeding."
echo ""
read -p "Do you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Operation cancelled."
    exit 1
fi

echo "🧹 Cleaning git history..."

# Create a backup branch
echo "📦 Creating backup branch..."
git branch backup-before-cleanup

# Remove firebase_options.dart from git history
echo "🔥 Removing lib/firebase_options.dart from git history..."
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch lib/firebase_options.dart' \
  --prune-empty --tag-name-filter cat -- --all

# Clean up the backup files created by filter-branch
echo "🧽 Cleaning up temporary files..."
rm -rf .git/refs/original/
git reflog expire --expire=now --all
git gc --prune=now --aggressive

echo "✅ Git history cleaned!"
echo ""
echo "📋 Next steps:"
echo "1. Review the changes: git log --oneline"
echo "2. Test your application thoroughly"
echo "3. Force push to remote: git push origin --force --all"
echo "4. Force push tags: git push origin --force --tags"
echo "5. Inform team members about the history rewrite"
echo ""
echo "🔄 To restore from backup if needed:"
echo "git checkout backup-before-cleanup"
echo ""
echo "⚠️  IMPORTANT: After force pushing, all team members will need to:"
echo "git fetch origin"
echo "git reset --hard origin/main  # or your main branch name"
