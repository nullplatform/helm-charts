module.exports = {
    extends: ['@commitlint/config-conventional'],
    rules: {
        // Turn off rules that would conflict with our ticket number format
        'subject-case': [0], // Disable case checking for subject
        'header-max-length': [2, 'always', 100], // Allow longer headers to accommodate ticket numbers

        // Core rules we want to keep
        'subject-empty': [2, 'never'],
        'type-empty': [2, 'never'],
        'subject-full-stop': [2, 'never', '.'],
        'type-enum': [
            2,
            'always',
            [
                'feat',
                'fix',
                'docs',
                'style',
                'refactor',
                'perf',
                'test',
                'build',
                'ci',
                'chore',
                'revert'
            ]
        ]
    },
    // Use a custom parser to extract the ticket number correctly
    parserPreset: {
        parserOpts: {
            // Updated to match: chore(config): BAC-1234 this is a test
            headerPattern: /^(\w*)(?:\(([a-z0-9-]*)\))?: ([A-Z]+-[0-9]+) (.*)$/,
            headerCorrespondence: ['type', 'scope', 'ticket', 'subject']
        }
    }
};