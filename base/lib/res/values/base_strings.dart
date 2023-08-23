class BaseStrings {
  static final BaseStrings instance = BaseStrings();

  final String appName = "Cybernet";
  final String networkError =
      "Please check your network connection or contact your service provider if the problem persists.";
  final String errorMessage = "An error occurred. Please try again.";

  final String fixErrors = "Please fix the errors in red before submitting";
  final String leavingEmptyMeasures =
      "Leaving Measurements empty? Click on Scissors button.";
  final List<String> monthsShort = <String>[
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sept",
    "Oct",
    "Nov",
    "Dec",
  ];
  final List<String> monthsFull = <String>[
    "January",
    "Febuary",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  //Errors
  final userName_error = "UserName is mandatory";
  final password_error = "Password is mandatory";
  final clientid_error = "clientid is mandatory";
}
