# Bash Task Organizer

A lightweight, terminal-based task management tool written in Bash. This script allows you to manage your daily tasks directly from your CLI using a simple pipe-separated text database.

##  Features
* **Colorized Interface:** Easy-to-read, color-coded terminal output.
* **CRUD Operations:** Add, List, Update, and Delete tasks seamlessly.
* **Smart Date Handling:** Input dates as `YYYY-MM-DD` or simply enter a number (e.g., `5`) to set a deadline a specific number of days from today.
* **Search Functionality:** Case-insensitive search to find tasks by title.
* **Persistent Storage:** Saves all tasks to a local `tasks_db` file.
* **Input Validation:** Prevents broken records by validating special characters and date formats.

---

##  Getting Started
### Prerequisites
You will need a Unix-like environment (Linux, macOS, WSL) with the following utilities (usually pre-installed):

* `bash`
* `awk`
* `sed`
* `column`

### Installation

1. Save the script as `tasks.sh`.
2. Give the script execution permissions:
```bash
chmod +x tasks.sh
```

### Usage
Run the script to start the interactive menu:
```bash
./tasks.sh

```

---

## Menu Options

| Option | Action          | Description                                                      |
| ------ | --------------- | ---------------------------------------------------------------- |
| **1**  | **Add Task**    | Create a new task with title, priority (h/m/l), and due date.    |
| **2**  | **List Tasks**  | View all currently stored tasks in a formatted table.            |
| **3**  | **Update Task** | Modify the title, priority, date, or status of an existing task. |
| **4**  | **Delete Task** | Remove a task from the database by its ID.                       |
| **5**  | **Search**      | Search for tasks by keywords in the title.                       |
| **9**  | **Quit**        | Exit the application.                                            |

---

## Database Structure

The script automatically creates a file named `tasks_db` in the same directory. Data is stored in the following format:
`id | title | priority | date | status`

> [!TIP]
> Do not manually edit the `tasks_db` file unless you are comfortable with pipe-separated values, as it may interfere with the script's ID tracking.

---

## License

This project is open-source and free to use.

**Created by Ali Algohary**
