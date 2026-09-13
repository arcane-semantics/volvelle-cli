import subprocess
from argparse import Namespace

from volvelle.utils.io import fatal, warn


class Command:
    args: Namespace

    def __init__(self, args: Namespace) -> None:
        self.args = args

    def run(self) -> None:
        """Open clipboard history or report that it has no entries yet."""
        try:
            clip = subprocess.run(
                ["cliphist", "list"],
                check=True,
                capture_output=True,
            ).stdout
        except FileNotFoundError:
            fatal("cliphist is not installed")
        except subprocess.CalledProcessError as error:
            detail = error.stderr.decode(errors="replace").strip()
            if "please store something first" in detail:
                warn("Clipboard history is empty")
                return
            fatal(f"failed to read clipboard history: {detail or error}")

        if not clip:
            warn("Clipboard history is empty")
            return

        if self.args.delete:
            args = ["--prompt=del > ", "--placeholder=Delete from clipboard"]
        else:
            args = ["--placeholder=Type to search clipboard"]

        picker_command = ["fuzzel", "--dmenu", *args]
        chosen = subprocess.check_output(picker_command, input=clip)

        if self.args.delete:
            subprocess.run(["cliphist", "delete"], input=chosen, check=True)
        else:
            decode_command = ["cliphist", "decode"]
            decoded = subprocess.check_output(decode_command, input=chosen)
            subprocess.run(["wl-copy"], input=decoded, check=True)
