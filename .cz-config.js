module.exports = {
    types: [
        { value: 'feat', name: 'feat:     A new feature' },
        { value: 'fix', name: 'fix:      A bug fix' },
        { value: 'docs', name: 'docs:     Documentation only changes' },
        { value: 'style', name: 'style:    Changes that do not affect the meaning of the code' },
        { value: 'refactor', name: 'refactor: A code change that neither fixes a bug nor adds a feature' },
        { value: 'perf', name: 'perf:     A code change that improves performance' },
        { value: 'test', name: 'test:     Adding missing tests or correcting existing tests' },
        { value: 'build', name: 'build:    Changes that affect the build system or external dependencies' },
        { value: 'ci', name: 'ci:       Changes to our CI configuration files and scripts' },
        { value: 'chore', name: 'chore:    Other changes that don\'t modify src or test files' },
        { value: 'revert', name: 'revert:   Reverts a previous commit' }
    ],

    // Updated project-specific scopes
    scopes: [
        { name: 'agent' },
        { name: 'base' },
        { name: 'cert-manager-config' },
        { name: 'config' }
    ],

    // Ask for ticket number
    ticketNumberPrefix: '',
    // Regex to validate BAC-1234 format (letters, dash, numbers)
    ticketNumberRegExp: '[A-Z]+-[0-9]+',

    // Override the messages
    messages: {
        type: 'Select the type of change that you\'re committing:',
        scope: '\nDenote the SCOPE of this change (optional):',
        customScope: 'Denote the SCOPE of this change:',
        subject: 'Write a SHORT, IMPERATIVE description of the change:\n',
        body: 'Provide a LONGER description of the change (optional). Use "|" to break new line:\n',
        breaking: 'List any BREAKING CHANGES (optional):\n',
        footer: 'List any ISSUES CLOSED by this change (optional). E.g.: #31, #34:\n',
        confirmCommit: 'Are you sure you want to proceed with the commit above?',
        ticketNumber: 'Enter TICKET number (required):'
    },

    // Allow custom questions
    questions: {
        ticketNumber: {
            description: 'Enter ticket number (e.g. BAC-1234):',
            required: true,
            validate: function(value) {
                return /^[A-Z]+-[0-9]+$/.test(value) || 'Ticket number must be in format BAC-1234';
            }
        }
    },

    // Force having ticket number
    allowTicketNumber: true,
    isTicketNumberRequired: true,

    // Include breaking changes in subject for major releases
    allowBreakingChanges: ['feat', 'fix'],

    // Skip questions which you want to not ask
    skipQuestions: ['footer'],

    // Limit subject length
    subjectLimit: 100,

    // Build the commit message format with ticket number BEFORE the description
    formatMessageCb: function(answers) {
        const ticket = answers.ticketNumber.trim();
        const type = answers.type;
        const scope = answers.scope ? `(${answers.scope})` : '';
        const subject = answers.subject.trim();
        const breaking = answers.breaking ? `BREAKING CHANGE: ${answers.breaking.trim()}` : '';
        const body = answers.body ? answers.body.trim() : '';

        // Format with ticket number BEFORE subject, without brackets
        let message = `${type}${scope}: ${ticket} ${subject}`;

        if (body) {
            message += `\n\n${body}`;
        }

        if (breaking) {
            message += `\n\n${breaking}`;
        }

        return message;
    }
};