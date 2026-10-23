# Git Harpoon File Update Script

[ThePrimeagen/harpoon](https://github.com/ThePrimeagen/harpoon/tree/harpoon2)

This script updates the Harpoon project file with a list of files modified in the specified Git commits on the current branch. It ensures that the files are added with their positions (`col: 0`, `row: 1`) as required by the Harpoon format.

## Requirements

- **harpoon 2**: The neovim plugin to manage files in a Git repostory.
- **git**: The script requires that you have a Git repository in the current directory.
- **jq**: The script uses `jq` to manipulate the Harpoon data file.

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

This will add the modified files from the specified commit range into the current project's Harpoon data file with `col: 0` and `row: 1` for each file.

### Example of Harpoon JSON Update:

If the following files are modified:

- `src/Form/HospitalType.php`
- `templates/Admin/Hospital/createEditeHospital.html.twig`
- `translations/Admin/messages.fr.yml`

The script will update the project's Harpoon data file, `~/.local/share/nvim/harpoon/<sha256 of the project path>.json`, in the format:

```json
{
  "/path/to/your/project": {
    "__harpoon_files": [
      "{\"value\":\"src/Form/HospitalType.php\",\"context\":{\"col\":0,\"row\":1}}",
      "{\"value\":\"templates/Admin/Hospital/createEditeHospital.html.twig\",\"context\":{\"col\":0,\"row\":1}}",
      "{\"value\":\"translations/Admin/messages.fr.yml\",\"context\":{\"col\":0,\"row\":1}}"
    ]
  }
}
```

### Notes:

- The script uses the current directory as the project path for the Harpoon data file update. The file is created if it does not exist, and the other lists it contains are kept.

- The modified files replace the `__harpoon_files` list. Each item is a JSON-encoded string with the format:

```json
{ "value": "<modified_file_path>", "context": { "col": 0, "row": 1 } }
```

- Harpoon keeps its lists in memory: close Neovim before running the script, or restart it afterwards, otherwise your changes may be overwritten.

## Troubleshooting

**"This directory is not a Git repository."**: Ensure you are in a Git repository.
**"No modified files found in the specified commits."**: Make sure the commit range is correct and that there are actual file changes in that range.

## License

This script is available under the GPL v3 License.
