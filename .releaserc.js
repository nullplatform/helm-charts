module.exports = {
  branches: ["main", "master", "feature/semver"],
  plugins: [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/changelog",
    // Each plugin needs its own array entry
    [
      "semantic-release-helm",
      {
        chartPath: "./charts/base"
      }
    ],
    [
      "semantic-release-helm",
      {
        chartPath: "./charts/cert-manager-config"
      }
    ],
    [
      "@semantic-release/git",
      {
        assets: ["charts/**/Chart.yaml", "CHANGELOG.md"],
        message: "chore(release): GIT-0000 ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}"
      }
    ],
    "@semantic-release/github"
  ]
}