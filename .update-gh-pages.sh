# https://www.innoq.com/en/blog/github-actions-automation/

# This script assumes that "make pkgdown" has been run before.

set -eu

repo_uri="https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
remote_name="origin"
main_branch="master"
target_branch="gh-pages"

cd "$GITHUB_WORKSPACE"

git config user.name "$GITHUB_ACTOR"
git config user.email "${GITHUB_ACTOR}@bots.github.com"

git checkout "$main_branch"
git branch -D "$target_branch"
if [ $? -ne 0 ]; then
    echo "gh-pages branch did not exist."
fi
git branch -c "$target_branch"
git checkout "$target_branch"

# Remove all non-docs files
rm -fr man/ R/ tests/ vignettes/
rm -f DESCRIPTION Makefile NAMESPACE _pkgdown.yml README.md
# Move docs to the root folder
mv docs/* .
rm -fr docs/
# Prepare the commit
git add --force .

git commit -m "Updated GitHub pages"
if [ $? -ne 0 ]; then
    echo "Nothing to commit"
    exit 0
fi

git remote set-url "$remote_name" "$repo_uri"
git push --force "$remote_name" "$target_branch"
