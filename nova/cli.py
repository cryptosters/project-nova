import argparse, sys, json, os
from .banner import banner

def main():
    print(banner())

    parser = argparse.ArgumentParser(
        prog="nova",
        description="NOVA CLI — starter skeleton para sa Termux app mo."
    )
    sub = parser.add_subparsers(dest="cmd")

    # nova hello -n mamon
    hello = sub.add_parser("hello", help="Test command")
    hello.add_argument("--name", "-n", default="mamon", help="Pangalan na babatiin")

    # nova config --json
    cfg = sub.add_parser("config", help="Ipakita ang config")
    cfg.add_argument("--json", action="store_true", help="Output sa JSON")

    args = parser.parse_args()

    if args.cmd == "hello":
        print(f"👋 Hello, {args.name}!")
        return 0

    if args.cmd == "config":
        conf = {
            "app": "NOVA",
            "version": "0.1.0",
            "paths": {
                "home": os.path.expanduser("~"),
                "nova_dir": os.path.join(os.path.expanduser("~"), "NOVA")
            }
        }
        if args.json:
            import json
            print(json.dumps(conf, indent=2))
        else:
            print("App: NOVA\nBersyon: 0.1.0\nHome:", conf["paths"]["home"])
            print("NOVA dir:", conf["paths"]["nova_dir"])
        return 0

    parser.print_help()
    return 0
