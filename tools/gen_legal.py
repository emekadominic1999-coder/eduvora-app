"""Generates the Terms of Use / Privacy Policy for the app AND the website.

Edit the text here, then run `py tools/gen_legal.py` from the repo root. It
rewrites lib/features/legal/legal_content.dart (in-app screens) and
web/terms.html + web/privacy.html (public links for Play Store / footer), so
the two can never drift apart.
"""
import html
import os

UPDATED = '20 September 2026'
CONTACT = 'hello@eduvora.ng'
OPERATOR = 'Eduvora, operated by Dominic Emeka, Nigeria'

TERMS = dict(
    key='terms', title='Terms of Use', file='terms.html',
    intro=('These terms explain how you may use Eduvora. By creating an account '
           'or using the app you agree to them. If you do not agree, please do '
           'not use Eduvora.'),
    sections=[
        ('Who we are', [
            f'Eduvora is an independent study app for Nigerian students. It is run by {OPERATOR}. You can reach us at {CONTACT}.',
            'Eduvora is NOT part of, affiliated with, or endorsed by the University of Nigeria, Nsukka or any other school, university, polytechnic or college. School names, course codes and logos are used only to show which school and course a page is for.',
        ], []),
        ('Practice questions are not official exams', [
            'CBT papers in Eduvora are practice questions written to help you revise. They are not official examination papers, they are not past questions unless clearly stated, and they do not predict what will appear in any real exam.',
            'We work hard to make the questions accurate, but we cannot promise they are free of mistakes. Always check important facts with your lecturer, course outline and recommended textbooks. We are not responsible for exam results.',
        ], []),
        ('Your account', [], [
            'You must be at least 16 years old to use Eduvora.',
            'Give accurate information and keep your password safe. You are responsible for what happens on your account.',
            'One person, one account. Do not share your account or paid access with other people.',
        ]),
        ('Acceptable use', ['When using Eduvora you agree not to:'], [
            'harass, bully, threaten or impersonate anyone;',
            'post hate speech, sexual content, or anything illegal;',
            'upload material you do not have the right to share, including copyrighted books, handouts or exam papers;',
            'cheat, leak real exam questions, or use Eduvora to help anyone cheat in an examination;',
            'copy, resell or scrape Eduvora questions or content, or try to break, overload or bypass the app or its payment system.',
            'We may remove content or suspend accounts that break these rules.',
        ]),
        ('Paid access', [
            'Some CBT papers can be unlocked for a fee. The price, what you get and how long access lasts are shown before you pay. Prices are in Nigerian naira (NGN).',
            'Payments are processed by Paystack. We never see or store your card details.',
            'Paid access is for your own use and is tied to one device at a time. If you need to move to a new device, contact us.',
            'Because access to digital content starts immediately, payments are non-refundable once access has been granted. If you were charged but access was not delivered, contact us with your payment reference and we will fix it or refund you.',
            'We may change prices or what is free or paid in future. Changes do not affect access you have already paid for.',
        ], []),
        ('Referral programme', [
            'You may share your referral code. When someone signs up with your code and makes a purchase, you earn a commission on that purchase (currently 10%), shown in the Refer and earn screen.',
        ], [
            'The minimum withdrawal is NGN 1,000.',
            'Payouts are made manually by us to the account you provide, and may take some days.',
            'Referring yourself, fake accounts, spam, or misleading people are not allowed. We may cancel commissions and close accounts where we find this.',
            'We may change or stop the programme, but commissions already earned will still be honoured.',
        ]),
        ('Content you post or upload', [
            'You keep ownership of what you post (materials, messages, community posts). By posting, you give Eduvora permission to store it and show it to other users as part of the app.',
            'You promise that you own it or have the right to share it. If you believe something on Eduvora infringes your rights, email us at ' + CONTACT + ' and we will review it promptly.',
        ], []),
        ('Our content', [
            'The Eduvora app, its design and the questions we write belong to us or our licensors. You may use them for your own personal study only.',
        ], []),
        ('Availability and changes', [
            'We try to keep Eduvora running, but we cannot promise it will always be available or error-free. We may change, pause or stop any feature.',
        ], []),
        ('Limits of liability', [
            'Eduvora is provided "as is". To the extent the law allows, we are not liable for indirect or consequential loss, or for exam results, arising from use of the app. Nothing in these terms removes any right you have under Nigerian law that cannot be removed.',
        ], []),
        ('Ending your account', [
            'You can stop using Eduvora any time. You can ask us to delete your account by emailing ' + CONTACT + '. We may suspend or close accounts that break these terms.',
        ], []),
        ('Changes and governing law', [
            'We may update these terms. When we make important changes we will tell you in the app. Continuing to use Eduvora after a change means you accept it.',
            'These terms are governed by the laws of the Federal Republic of Nigeria.',
        ], []),
        ('Contact', [f'Questions? Email {CONTACT}.'], []),
    ])

PRIVACY = dict(
    key='privacy', title='Privacy Policy', file='privacy.html',
    intro=('This policy explains what information Eduvora collects, why, and '
           'the choices you have. We handle your data in line with the Nigeria '
           'Data Protection Act 2023.'),
    sections=[
        ('Who is responsible', [f'{OPERATOR} is the controller of your data. Contact: {CONTACT}.'], []),
        ('What we collect', [], [
            'Account details: your name, email address and profile picture (if you sign in with Google), and your password if you use email sign-up (stored securely, never in plain text).',
            'Academic profile: your school, faculty, department, level, and optionally your matric number and bio.',
            'Your activity: CBT attempts and scores, courses you use, materials you upload, and posts, comments and messages you send in the community, groups, chats and tutor features.',
            'Payments: payment status and reference numbers from Paystack. We never see or store your card or bank login details.',
            'Referrals: your referral code, who you referred, commissions earned, and payout details you give us when withdrawing.',
            'Device information: a random device ID generated by the app, used to tie paid access to one device, plus basic technical data such as browser or app version.',
        ]),
        ('How we use it', [], [
            'To create your account and show you courses, papers and materials for your faculty and level.',
            'To unlock paid access, prevent misuse, and pay referral commissions.',
            'To run community features, keep the app safe, and respond to support requests.',
            'To improve Eduvora, for example by looking at which features are used.',
            'We do not sell your personal data.',
        ]),
        ('Who we share it with', ['We share data only with services that help us run Eduvora:'], [
            'Supabase, which hosts our database, sign-in and file storage;',
            'Google, if you choose to sign in with Google;',
            'Paystack, which processes payments;',
            'Vercel, which hosts the website version of Eduvora.',
            'Other students can see your name, profile picture, school and what you post publicly in the community. Your email, matric number and payment details are not shown to other students.',
            'We may also share information if the law requires it.',
        ]),
        ('Where it is stored', ['Your data is stored with our service providers, some of whom operate outside Nigeria. We choose providers that protect data with appropriate security.'], []),
        ('How long we keep it', ['We keep your data while your account is active. If you ask us to delete your account we will remove your personal data, except records we must keep for payments, fraud prevention or the law.'], []),
        ('Your rights', ['You can ask us to:'], [
            'give you a copy of your data;',
            'correct anything that is wrong (you can also edit most of it in your profile);',
            'delete your data or account;',
            'stop using your data for a particular purpose.',
            f'Email {CONTACT} and we will respond within a reasonable time. You also have the right to complain to the Nigeria Data Protection Commission.',
        ]),
        ('Security', ['We use reasonable technical measures to protect your data, but no system is perfectly secure. Keep your password private.'], []),
        ('Children', ['Eduvora is for students aged 16 and above. If you believe a younger child has signed up, email us and we will remove the account.'], []),
        ('Changes to this policy', ['We may update this policy. When we make important changes we will tell you in the app.'], []),
        ('Contact', [f'Questions or requests? Email {CONTACT}.'], []),
    ])

DOCS = [TERMS, PRIVACY]


def dq(s):
    """Dart single-quoted string literal."""
    return "'" + s.replace('\\', '\\\\').replace("'", "\\'").replace('$', '\\$') + "'"


def gen_dart():
    out = [
        '// GENERATED by tools/gen_legal.py -- edit the script, not this file.',
        "import 'package:flutter/foundation.dart';", '',
        '@immutable', 'class LegalSection {',
        '  const LegalSection(this.heading, this.paragraphs, this.bullets);',
        '  final String heading;', '  final List<String> paragraphs;',
        '  final List<String> bullets;', '}', '',
        '@immutable', 'class LegalDoc {',
        '  const LegalDoc({',
        '    required this.title,',
        '    required this.updated,',
        '    required this.intro,',
        '    required this.sections,',
        '  });',
        '  final String title;', '  final String updated;', '  final String intro;',
        '  final List<LegalSection> sections;', '}', '',
        'class LegalContent {',
    ]
    for d in DOCS:
        out.append(f"  static const LegalDoc {d['key']} = LegalDoc(")
        out.append(f"    title: {dq(d['title'])},")
        out.append(f'    updated: {dq(UPDATED)},')
        out.append(f"    intro: {dq(d['intro'])},")
        out.append('    sections: <LegalSection>[')
        for h, paras, bullets in d['sections']:
            ps = ', '.join(dq(p) for p in paras)
            bs = ', '.join(dq(b) for b in bullets)
            out.append(f'      LegalSection({dq(h)}, <String>[{ps}], <String>[{bs}]),')
        out.append('    ],')
        out.append('  );')
    out.append('}')
    with open('lib/features/legal/legal_content.dart', 'w', encoding='utf-8', newline='\n') as f:
        f.write('\n'.join(out) + '\n')


CSS = (
    "body{font-family:system-ui,-apple-system,Segoe UI,Roboto,sans-serif;line-height:1.6;color:#1b2430;background:#fff;margin:0}"
    "main{max-width:720px;margin:0 auto;padding:24px 16px 64px}h1{font-size:1.9rem;margin:.2em 0}"
    "h2{font-size:1.15rem;margin:1.6em 0 .4em}p,li{font-size:1rem}.muted{color:#5b6675;font-size:.9rem}"
    "a{color:#0b6b5f}nav a{margin-right:14px;font-size:.9rem}"
    "@media (prefers-color-scheme:dark){body{background:#12171d;color:#e6ebf0}.muted{color:#9aa6b4}a{color:#6fd3c3}}"
)


def gen_html():
    for d in DOCS:
        parts = [
            "<!doctype html><html lang='en'><head><meta charset='utf-8'>"
            "<meta name='viewport' content='width=device-width,initial-scale=1'>",
            f"<title>{html.escape(d['title'])} - Eduvora</title><style>{CSS}</style></head><body><main>",
            "<nav><a href='/'>Eduvora</a><a href='terms.html'>Terms of Use</a>"
            "<a href='privacy.html'>Privacy Policy</a></nav>",
            f"<h1>{html.escape(d['title'])}</h1><p class='muted'>Last updated: {UPDATED}</p>"
            f"<p>{html.escape(d['intro'])}</p>",
        ]
        for h, paras, bullets in d['sections']:
            parts.append(f'<h2>{html.escape(h)}</h2>')
            for p in paras:
                parts.append(f'<p>{html.escape(p)}</p>')
            if bullets:
                parts.append('<ul>' + ''.join(f'<li>{html.escape(b)}</li>' for b in bullets) + '</ul>')
        parts.append('</main></body></html>')
        with open(os.path.join('web', d['file']), 'w', encoding='utf-8', newline='\n') as f:
            f.write(''.join(parts))


gen_dart()
gen_html()
print('ok')
