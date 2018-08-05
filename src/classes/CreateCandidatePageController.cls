public class CreateCandidatePageController {

	public String clientFirstName { get; set; }
	public String clientLastName { get; set; }
	public String clientLogin { get; set; }
	public String clientRole { get; set; }
	public String clientEmail { get; set; }

	public String client { get; set; }

	public String candidateFirstName { get; set; }
	public String candidateLastName { get; set; }
	public String candidatePosition { get; set; }
	public String candidateHR { get; set; }
	public String candidateSalary { get; set; }
	public String candidateExperience { get; set; }
	public String candidatePhone { get; set; }
	public String candidateEmail { get; set; }
	public String candidateSkype { get; set; }
	public String candidateSourceCandidate { get; set; }
	public String candidateSourceCommunication { get; set; }

	public String messageError { get; set; }

	public String test { get; set; }

	public CreateCandidatePageController() {

		this.client = '';

		initClient();

		this.candidateFirstName = '';
		this.candidateLastName = ''; 
		this.candidatePosition = ''; 
		this.candidateHR = ''; 
		this.candidateSalary = ''; 
		this.candidateExperience = '';
		this.candidatePhone = '';
		this.candidateEmail = '';
		this.candidateSkype = '';
		this.candidateSourceCandidate = '';
		this.candidateSourceCommunication = '';

		this.messageError = '';

		//this.test = 'abrakadabra';

	}

	public void initClient() {

		this.clientLogin = (String)Cache.Session.get('local.X1234567890.client');
		test = clientLogin;

		List<Client__c> clts = (List<Client__c>)Database.query('SELECT Login__c, Employee__c FROM Client__c ' +
					+ ' WHERE Login__c = :clientLogin LIMIT 1');
		if (clts.size() == 0) {
			return;
		}
		Client__c clt = clts[0];
		Id cltEmpId = clt.Employee__c;
		List<Employee__c> empls = (List<Employee__c>)Database.query('SELECT FirstName__c, LastName__c, Role__c, Email__c ' +
					+ ' FROM Employee__c WHERE Id = :cltEmpId LIMIT 1');
		Employee__c emple = empls[0];

		this.clientFirstName = emple.FirstName__c;
		this.clientLastName = emple.LastName__c;
		this.clientLogin = clt.Login__c;
		this.clientRole = emple.Role__c;
		this.clientEmail = emple.Email__c;

		test += clientRole;
		if (clientRole != 'Manager') {
			return;
		}

		Map<String, String> clientMap = new Map<String, String>();
		clientMap.put('FirstName', clientFirstName);
		clientMap.put('LastName', clientLastName);
		clientMap.put('Login', clientLogin);
		clientMap.put('Role', clientRole);
		clientMap.put('Email', clientEmail);

		client = JSON.serialize(clientMap);
	}

	public PageReference exitToLoginPage() {
		Cache.Session.put('local.X1234567890.client', '');
		PageReference loginPage = Page.LoginPage;
      	loginPage.setRedirect(true);
		return loginPage;
	}

	public PageReference candidatesShow() {
		Cache.Session.put('local.X1234567890.client', clientLogin);
		PageReference candidatesPage = Page.CandidatesPageForManager;
      	candidatesPage.setRedirect(true);
		return candidatesPage;
    }

	public PageReference clientsShow() {
		Cache.Session.put('local.X1234567890.client', clientLogin);
		PageReference clientsPage = Page.ClientsPageForManager;
      	clientsPage.setRedirect(true);
		return clientsPage;
	}

	public PageReference employeesShow() {
		Cache.Session.put('local.X1234567890.client', clientLogin);
		PageReference employeesPage = Page.EmployeesPageForManager;
      	employeesPage.setRedirect(true);
		return employeesPage;
	}

	public PageReference createCandidate() {

		messageError = '';

		if (candidateFirstName == '' || candidateLastName == '' || candidatePosition == '' || candidateHR == '' || 
			candidateSalary == '' || candidateExperience == '' || candidatePhone == '') {
			messageError = 'Введите все поля!';
			messageError = JSON.serialize(messageError);
			return null;
		}
		
		test = candidateSourceCandidate + '::' + candidateSourceCommunication;

		List<Candidate__c> candidateCheck = new List<Candidate__c>();
		candidateCheck = (List<Candidate__c>) Database.query('SELECT Id FROM Candidate__c ' +
					+ ' WHERE FirstName__c = :candidateFirstName AND LastName__c = :candidateLastName LIMIT 1');
		if (candidateCheck.size() != 0) {
			messageError = 'Данный кандидат уже существует!';
			messageError = JSON.serialize(messageError);
			return null;
		}

		List<Employee__c> hrCheck = new List<Employee__c>();
		try {
			List<String> hrName = (List<String>) candidateHR.split(' ');
			String hrLastName = hrName[0];
			String hrFirstName = hrName[1];
			test = hrLastName + ' ' + hrFirstName;
			hrCheck = (List<Employee__c>) Database.query('SELECT Id FROM Employee__c ' +
						+ ' WHERE FirstName__c = :hrFirstName AND LastName__c = :hrLastName LIMIT 1');
			if (hrCheck.size() == 0) {
				messageError = 'Не найден введённый Вами HR!';
				messageError = JSON.serialize(messageError);
				return null;
			}
		} catch(Exception ex) {
			messageError = 'Проверьте правильность введённого поля:\nHR: (Фамилия Имя)';
			messageError = JSON.serialize(messageError);
			return null;
		}

		Double candidateSalaryDouble;
		try {
			candidateSalaryDouble = Double.valueOf(candidateSalary);
		} catch(Exception ex) {
			messageError = 'Проверьте правильность введённого поля:\nЗП: (Число)';
			messageError = JSON.serialize(messageError);
			return null;
		}

		Double candidateExperienceDouble;
		try {
			candidateExperienceDouble = Double.valueOf(candidateExperience);
		} catch(Exception ex) {
			messageError = 'Проверьте правильность введённого поля:\nОпыт: (Число)';
			messageError = JSON.serialize(messageError);
			return null;
		}

		if (!Pattern.matches('^[0-9]{12}$', candidatePhone)) {
			messageError = 'Проверьте правильность введённого поля:\nPhone: (375447662313)';
			messageError = JSON.serialize(messageError);
			return null;
		}

		if (candidateEmail != '' &&
			!Pattern.matches('^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$', candidateEmail)) {
			messageError = 'Проверьте правильность введённого поля:\nEmail: (___@___.___)';
			messageError = JSON.serialize(messageError);
			return null;
		}

		Candidate__c newCandidate = new Candidate__c(FirstName__c = candidateFirstName, 
													 LastName__c = candidateLastName, 
													 Position__c = candidatePosition, 
													 HR__c = hrCheck[0].Id, 
													 Salary__c = candidateSalaryDouble,
													 Experience__c = candidateExperienceDouble, 
													 Phone__c = candidatePhone, 
													 SourceCandidate__c = candidateSourceCandidate, 
													 SourceCommunication__c = candidateSourceCommunication,
													 Status__c = 'Start',
													 DatesOfCommunication__c = Datetime.now().format('dd-MM-yyyy HH:mm a'));
		if (candidateEmail != '') {
			newCandidate.Email__c = candidateEmail;
		}
		if (candidateSkype != '') {
			newCandidate.Skype__c = candidateSkype;
		}

		insert newCandidate;

		Cache.Session.put('local.X1234567890.client', clientLogin);
		Cache.Session.put('local.X1234567890.idEditCandidate', (String)newCandidate.Id);

		PageReference candidateViewPage = Page.CandidateViewPageForManager;
      	candidateViewPage.setRedirect(true);
		return candidateViewPage;

	}

}