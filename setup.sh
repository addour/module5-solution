#!/bin/bash

# Module 5 Assignment Setup Script
# This script copies the Lecture59 starter code to your repository

echo "Setting up Module 5 Assignment..."

# Clone the course repository
git clone https://github.com/jhu-ep-coursera/fullstack-course5.git temp-course

# Copy Lecture59 files
cp -r temp-course/examples/Lecture59/* .

# Remove the temporary course folder
rm -rf temp-course

echo "Starter code copied successfully!"
echo "Now you need to:"
echo "1. Implement the Sign Up form"
echo "2. Implement the My Info page"
echo "3. Test locally"
echo "4. Commit and push: git add . && git commit -m 'Add assignment implementation' && git push"
echo "5. Enable GitHub Pages in Settings"
echo "6. Submit on Coursera with URL: https://addour.github.io/module5-solution"
