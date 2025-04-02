# Git Harpoon File Update Script

This script updates the Harpoon project file with a list of files modified in the specified Git commits on the current branch. It ensures that the files are added with their positions (`col: 0`, `row: 1`) as required by the Harpoon format.

## Requirements

- **git**: The script requires that you have a Git repository in the current directory.
- **jq**: The script uses `jq` to manipulate the `harpoon.json` file.

## Installation

Run the following commands to install the script:

```bash
git clone https://github.com/theophilebrun/git-harpoon.git
cd git-harpoon
chmod +x update-harpoon.sh
```

(Optional) Add an alias to your .bashrc or .zshrc for easier execution

For .bashrc users
```bash
echo "alias gdhp='bash $(pwd)/update-harpoon.sh'" >> ~/.bashrc
source ~/.bashrc
```

For .zshrc users
```bash
echo "alias gdhp='bash $(pwd)/update-harpoon.sh'" >> ~/.zshrc
source ~/.zshrc
```

## Usage

### Syntax

```bash
./<script_name>.sh <commit/range>
```
- `<commit/range>`: The commit hash or range (e.g., HEAD~5..HEAD) to check for modified files.

### Example:

To update the Harpoon file with modified files from the last 5 commits:

```bash
./<script_name>.sh HEAD~5..HEAD
```

This will add the modified files from the specified commit range into the current project's section in the `harpoon.json` file with `col: 0` and `row: 1` for each file.

### Example of Harpoon JSON Update:

If the following files are modified:

- `src/Form/HospitalType.php`
- `templates/Admin/Hospital/createEditeHospital.html.twig`
- `translations/Admin/messages.fr.yml`

The script will update the `harpoon.json` file in the format:

```json
{
  "projects": {
    "/path/to/your/project": {
      "mark": {
        "marks": [
          {"col": 0, "row": 1, "filename": "file1"},
          {"col": 0, "row": 1, "filename": "file2"},
          {"col": 0, "row": 1, "filename": "file3"}
        ]
      },
      "term": {"cmds": []}
    }
  },
  "global_settings": {
    "mark_branch": false,
    "save_on_toggle": false,
    "tabline": false,
    "excluded_filetypes": ["harpoon"],
    "save_on_change": true,
    "tabline_suffix": "   ",
    "enter_on_sendcmd": false,
    "tabline_prefix": "   ",
    "tmux_autoclose_windows": false
  }
}
```

### Notes:

- The script uses the current directory as the project path for the Harpoon JSON file update.

- The modified files are added under the key `mark.marks` with the format:

```json
{ "col": 0, "row": 1, "filename": "<modified_file_path>" }
```

## Troubleshooting

**"This directory is not a Git repository."**: Ensure you are in a Git repository.
**"No modified files found in the specified commits."**: Make sure the commit range is correct and that there are actual file changes in that range.

## License

This script is available under the GPL v3 License.
