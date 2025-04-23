module.exports = {
  branches: ["main", "master","feature/semver"],
  plugins: [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/changelog",
    [
      "semantic-release-helm",
      {
        // Target all charts in the charts directory
        chartPath: "./charts",
        // Optionally, you can update appVersion as well if needed
        // onlyUpdateVersion: false
      }
    ],
    [
      "@semantic-release/git",
      {
        assets: ["charts/**/Chart.yaml", "CHANGELOG.md"],
        message: "chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}"
      }
    ],
    "@semantic-release/github"
  ]
}