# Sometimes it's a README fix, or something like that - which isn't relevant for
# including in a project's CHANGELOG for example
declared_trivial = github.pr_title.include? "#trivial"

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"

# ENSURE THAT LABELS HAVE BEEN USED ON THE PR
warn("Please add labels to this PR") if github.pr_labels.empty?

# ENSURE THERE IS A SUMMARY FOR A PR
fail("Please provide a summary in the Pull Request description") if github.pr_body.length < 5

# ENSURE THAT ALL PRS HAVE AN ASSIGNEE
warn("This PR does not have any assignees yet.") unless github.pr_json["assignee"]

# DON'T ALLOW A FILE TO BE DELETED
# deleted = git.added_files.include? "my/favourite.file"
# failure "Don't delete my precious" if deleted

# Warn when there is a big PR
warn("Big PR") if git.lines_of_code > 500

files_changed = git.added_files.count + git.deleted_files.count + git.modified_files.count
fail("Big PR (files changed: #{files_changed} and max allowed is 7)") if files_changed > 7

# Don't let testing shortcuts get into master by accident
# fail("fdescribe left in tests") if `grep -r fdescribe specs/ `.length > 1
# fail("fit left in tests") if `grep -r fit specs/ `.length > 1

# swiftlint.max_num_violations = 20
swiftlint.lint_files fail_on_error: true

# fail("This PR has some lint errors that needs to be fixed") if !swiftlint.errors.empty?
fail("This PR exceeds the max number of lint warnings allowed (max allowed is 3)") if swiftlint.warnings.count > 3

xcov.report(
   scheme: 'bitrise-sample',
   # workspace: 'Example/EasyPeasy.xcworkspace',
   exclude_targets: 'bitrise-sample.app',
   minimum_coverage_percentage: 60
)
