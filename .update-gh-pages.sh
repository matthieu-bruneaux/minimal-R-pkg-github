# Modified from https://www.innoq.com/en/blog/github-actions-automation/

set -eu

repo_uri="https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"

git config user.name "$GITHUB_ACTOR"
git config user.email "${GITHUB_ACTOR}@bots.github.com"

git add --force .

git commit -m "Updated GitHub pages"
if [ $? -ne 0 ]; then
    echo "Nothing to commit"
    exit 0
fi

git remote set-url origin "$repo_uri"
git push --force origin gh-pages
