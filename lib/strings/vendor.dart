var email = 'bill07wang@gmail.com';
var repoURL = 'https://github.com/billcoding/mysql-client-flutter';
var emailSubject = 'About the MySQL client on iOS';
var emailSubjectEncode = emailSubject.replaceAll(r' ', '%20');
var issuesURL =
    'https://github.com/billcoding/mysql-client-flutter/issues/new?title=$emailSubjectEncode';
var mailTo = 'mailto:$email?subject=$emailSubjectEncode';
var version = '1.0.0';
var copyright = 'billcoding, @2021';
