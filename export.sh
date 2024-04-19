
# Parse script arguments to get the issue number
while getopts ":i:" opt; do
    case $opt in
        i)
            issue_number=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# Check if the issue number is provided
if [ -z "$issue_number" ]; then
    echo "Issue number is required (for example, $0 -i 80)"
    exit 1
fi

repo="zmoog/public-notes"
owner="zmoog"
# issue_number="80"

#
# https://docs.github.com/en/rest/issues/issues?apiVersion=2022-11-28#get-an-issue
#

gh api \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    /repos/$repo/issues/$issue_number | jq -r '.body' > $issue_number.md

#
#  https://docs.github.com/en/rest/issues/comments?apiVersion=2022-11-28#list-issue-comments
# 
# GitHub CLI api
# https://cli.github.com/manual/gh_api

gh api \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    repos/$repo/issues/$issue_number/comments | jq -r '.[].body' >> $issue_number.md


# Convert markdown to asciidoc
pandoc $issue_number.md -o $issue_number.adoc
