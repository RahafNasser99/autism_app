import 'dart:convert';

Domain domainFromJson(String str) => Domain.fromJson(json.decode(str));

class Domain {
  final int domainId;
  final String domainName;

  Domain({required this.domainId, required this.domainName});

  factory Domain.fromJson(Map<String, dynamic> json) {
    return Domain(domainId: json['id'], domainName: json['domain']);
  }

  @override
  String toString() =>
      'Domain ( \n' 'domainId: $domainId,  \n' 'domainName: $domainName \n' ')';
}