 module.exports = {
   branches: [
     {name: "main"},
     {name: "master"},
     {name: "release", prerelease: false}
  ],
  prerelease: false,
  tagFormat: '${version}',
  plugins: [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/changelog",
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
    [
      "@semantic-release/github",
      {
        // Add "Release" prefix to title
        releasedLabels: false,
        releaseNameTemplate: "Release <%= nextRelease.version %>",
        // Make it a full release, not prerelease
        successComment: false,
        failTitle: false,
        failComment: false,
        // Force the release to be a full release
        prerelease: false
      }
    ]
  ]
}