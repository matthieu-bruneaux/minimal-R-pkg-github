# https://www.innoq.com/en/blog/github-actions-automation/

set -eu

repo_uri="https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
remote_name="origin"
main_branch="master"
target_branch="gh-pages"
build_dir="docs"

cd "$GITHUB_WORKSPACE"

git config user.name "$GITHUB_ACTOR"
git config user.email "${GITHUB_ACTOR}@bots.github.com"

git checkout "$target_branch"
git rebase "${remote_name}/${main_branch}"

rm -fr docs/
make pkgdown
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
git push --force-with-lease "$remote_name" "$target_branch"
