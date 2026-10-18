/// What kind of user-generated content a report points at. The stored value
/// (see [value]) is plain text in the database, not a Postgres enum, so a
/// new surface can start reporting into `content_reports` without a schema
/// change.
enum ReportedContentType {
  groupMessage('group_message'),
  communityPost('community_post'),
  communityComment('community_comment');

  const ReportedContentType(this.value);

  final String value;
}

/// Why a student is reporting something. Mirrors the choices offered in the
/// report sheet; 'other' always carries a free-text note alongside it.
enum ReportReason {
  spam('Spam'),
  harassment('Harassment or bullying'),
  inappropriate('Inappropriate content'),
  other('Something else');

  const ReportReason(this.label);

  final String label;
}
