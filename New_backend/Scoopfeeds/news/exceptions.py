from rest_framework.exceptions import APIException

class WrongQueryParamsExeption(APIException):
    status_code = 400
    default_detail = {"status_code": 400, "error_message": "Wrong value for parameter type"}