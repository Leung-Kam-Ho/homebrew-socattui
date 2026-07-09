# Homebrew Python CLI Release Guide

Here is a complete, step-by-step summary of the entire lifecycle for distributing a Python CLI tool via a custom Homebrew tap with pre-compiled "bottles". 

This is the exact architecture used for `socattui`.

---

### Phase 1: Preparing your Main Code Repo
Before Homebrew can package your tool, it needs a stable release.
1. **Manage Dependencies:** Ensure your project is packaged properly (e.g., using `pyproject.toml` with `hatchling` or `setuptools`).
2. **Release a Version:** Bump your version number in your code.
3. **Tag and Push:** Create a git tag (e.g., `git tag v1.0.0`) and push it to GitHub. This tells GitHub to permanently freeze that version into a source `.tar.gz` download file.

---

### Phase 2: Creating the Homebrew Tap
A "Tap" is just a dedicated GitHub repository that holds Homebrew instructions (called Formulae) for your tools.
1. **Create the Repo:** Create a repository named `homebrew-<something>`.
2. **Generate Templates:** Run `brew tap-new <your-username>/<your-repo-name>` to locally generate the standard `.github/workflows/tests.yml` and `publish.yml` templates. Copy these to your repository.
3. **Write the Formula:** Create a file at `Formula/<toolname>.rb`. This Ruby script tells Homebrew where to download your source `.tar.gz` and provides its SHA256 checksum for security.
4. **Generate Python Dependencies:** Because Homebrew creates a strict, isolated virtual environment, use `homebrew-pypi-poet` to generate a `resource` block for *every single dependency* your app uses and paste them into the formula. 

---

### Phase 3: The Routine Release Workflow (How to update it)
Follow this workflow every time you release a new version (e.g., `v0.3.0`).

#### Step 1: Release the Code
1. Update the version to `0.3.0` in your main code repository.
2. Run `git tag v0.3.0` and `git push origin v0.3.0`.
3. Get the SHA256 of the new `.tar.gz` release: 
   `curl -sL https://github.com/Leung-Kam-Ho/SocatTUI/archive/refs/tags/v0.3.0.tar.gz | shasum -a 256`

#### Step 2: Update the Formula
1. In your `homebrew-something` tap repo, create a **new branch** (e.g., `git checkout -b update-v0.3.0`).
2. Update the `url` and `sha256` lines in `Formula/<toolname>.rb` to match the new release.
3. Commit and push the branch.

#### Step 3: Trigger the Bottle Build (The Magic Step)
1. Open a **Pull Request** from that branch on GitHub.
2. **Wait for the Tests:** GitHub Actions will automatically trigger `brew test-bot`. This boots up Mac and Linux servers, downloads your source code, and builds the app from scratch. It then zips the compiled output into a "bottle" (`.tar.gz`) and attaches it to the Pull Request.
3. **DO NOT click the green "Merge" button on the Pull Request.**
4. **Run PR-Pull:** Go to your GitHub repository's **"Actions"** tab. Click **"brew pr-pull"** on the left, then click the **"Run workflow"** button on the right. Type in your Pull Request number.

#### What `brew pr-pull` does automatically:
When you run that workflow, GitHub performs these actions autonomously:
1. It downloads the freshly built bottles from your Pull Request.
2. It uploads them to your GitHub Packages registry (so users can download them).
3. It rewrites your `Formula/<toolname>.rb` file to inject a `bottle do ... end` block containing the download links and security hashes for the bottles.
4. It merges the Pull Request into `main` for you.

---

### Phase 4: User Installation
Once the bot merges the PR, the release is live. 

1. **Add the Tap:** The user runs `brew tap <username>/<tap-name>` (and `brew trust` if it's their first time).
2. **Install:** They run `brew install <toolname>`.
3. **The Result:** Because your formula now has a `bottle` block, Homebrew skips the slow compilation process, downloads the pre-built bottle from GitHub Packages, unzips it, and the tool is installed and ready to use in **2 seconds**.