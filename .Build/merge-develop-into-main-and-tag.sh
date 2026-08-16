# 1. Switch to main
git checkout main

# 2. Pull latest main from upstream
git pull origin main

# 3. Merge develop into main without fast-forward
git merge develop --no-ff -m "Merge develop into main"

# 4. Extract the latest tag and reassign it to current HEAD
TAG=$(git describe --tags --abbrev=0)
git tag -f "$TAG" HEAD

# 5. Push main and the force-updated tag to upstream
git push origin main
git push origin -f "$TAG"

# 6. Switch back to develop
git checkout develop
