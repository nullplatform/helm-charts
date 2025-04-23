 module.exports = {
   branches: [
     {name: "main", channel: "latest", prerelease: false},
     {name: "master", channel: "latest", prerelease: false},
     {name: "release", channel: "latest", prerelease: false}
  ],
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
        releaseNameTemplate: "Release <%= nextRelease.version %>",
        successComment: false,
        failTitle: false,
        failComment: false,
        prerelease: false
      }
    ]
  ]
}