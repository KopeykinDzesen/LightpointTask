public class LoginPageController {

	public String FirstName { get; set; }
	public String LastName { get; set; }
	public String Login { get; set; }
	public String Password { get; set; }
	public String ConfirmPassword { get; set; }

	public String MessageError { get; set; }
	public String Result { get; set; }

	public String client { get; set; }

	public LoginPageController() {
		this.FirstName = '';
		this.LastName = '';
		this.Login = '';
		this.Password = '';
		this.ConfirmPassword = '';

		this.MessageError = '';
		this.Result = '';

		client = (String)Cache.Session.get('client');

	}

	public PageReference registration() {

		MessageError = '';

		if (FirstName == '' || LastName == '' || Login == '' || Password == '' || ConfirmPassword == '') {
			MessageError = 'Введите все поля!';
			MessageError = JSON.serialize(MessageError);
			return null;
		}

		if (Password != ConfirmPassword) {
			MessageError = 'Пароли не совпадают!';
			MessageError = JSON.serialize(MessageError);
			return null;
		}

		if (Database.query('SELECT Id FROM Client__c ' +
			+ ' WHERE Login__c = :Login LIMIT 1').size() > 0) {
			MessageError = 'Данный Логин занят!';
			MessageError = JSON.serialize(MessageError);
			return null;
		}

		List<Employee__c> employees = new List<Employee__c>();
		employees = (List<Employee__c>) Database.query('SELECT Id FROM Employee__c ' +
					+ ' WHERE FirstName__c = :FirstName AND LastName__c = :LastName LIMIT 1');
		
		if (employees.size() == 0) {
			MessageError = 'Сотрудник не найден! Проверьте введённые Имя и Фамилию.';
			MessageError = JSON.serialize(MessageError);
			return null;
		}

		Id employeeId = employees[0].Id;
		List<Client__c> clients = new List<Client__c>();
		clients = (List<Client__c>) Database.query('SELECT Id FROM Client__c ' +
					+ ' WHERE Employee__c = :employeeId LIMIT 1');
		if (clients.size() == 1) {
			MessageError = 'Сотрудник уже зарегистрирован!';
			MessageError = JSON.serialize(MessageError);
			return null;
		}

		Client__c newClient = new Client__c(Login__c = Login, Password__c = Password, 
					DateOfRegistration__c = Date.today(), Employee__c = employeeId);

		insert newClient;

		Cache.Session.put('local.X1234567890.client', Login);

		PageReference candidatesPage = Page.CandidatesPageForManager;
      	candidatesPage.setRedirect(true);
		return candidatesPage;

	}

	public PageReference login() {

		MessageError = '';

		if (Login == '' || Password == '') {
			MessageError = 'Введите все поля!';
			MessageError = JSON.serialize(MessageError);
			return null;
		}

		List<Client__c> client = new List<Client__c>();
		client = (List<Client__c>) Database.query('SELECT Password__c, Employee__c FROM Client__c ' +
														+ 'WHERE Login__c = :Login LIMIT 1');
		if (client.size() == 0) {
			MessageError = 'Проверьте введённый Логин!';
			MessageError = JSON.serialize(MessageError);
			return null;
		}

		if (client[0].Password__c != Password) {
			MessageError = 'Неверный пароль!';
			MessageError = JSON.serialize(MessageError);
			return null;
		}

		Cache.Session.put('local.X1234567890.client', Login);

		PageReference candidatesPage = Page.CandidatesPageForManager;
      	candidatesPage.setRedirect(true);
		return candidatesPage;

	}

}