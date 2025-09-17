module.exports = {
    extends: ['@commitlint/config-conventional'],
    rules: {
        'subject-case': [0, 'always', ['lower-case']], // Disable case checking for subject
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
        ],
        'body-max-line-length': [0] // Setting to 0 disables the rule
    },
    parserPreset: {
        parserOpts: {
            headerPattern: /^(\w*)(?:\(([a-z0-9-]*)\))?: (?:([A-Z]+-[0-9]+) )?(.*)$/,            
            headerCorrespondence: ['type', 'scope', 'ticket', 'subject']
        }
    }
};

