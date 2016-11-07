Project initial setup:

Please upload the "Category and JobTypes.xls" before calling the APIs.


## TEST APIs

1.Payment Order

http://test.com:9000/PaymentGateway/payments?name=&email=&amount=100&description=Test&phone=&macId=&mallId=

2.Get User Ecash:

http://localhost:8081/Instamojo/getUserEcash?macId=&mallId=

3.Create New Ecash Object

http://localhost:8081/Instamojo/createUserEcashByPId?paymentId=&mallId=

4.Update User Cash:

http://localhost:8081/Instamojo/updateEcash?macId=&ecash=30&toUserMacId=&mallId=



## Production APIs

1.Payment Order

http://54.179.48.83:9000/PaymentGateway/payments?name=&email=&amount=100&description=Test&phone=&macId=&mallId=

2.Get User Ecash:

http://storeongo.com:8081/Instamojo/getUserEcash?macId=&mallId=

3.Create New Ecash Object

http://storeongo.com:8081/Instamojo/createUserEcashByPId?paymentId=&mallId=

4.Update User Cash:

http://storeongo.com:8081/Instamojo/updateEcash?macId=&ecash=30&toUserMacId=&mallId=
