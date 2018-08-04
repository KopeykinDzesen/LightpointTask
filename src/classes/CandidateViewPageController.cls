public class CandidateViewPageController {

	public String clientFirstName { get; set; }
	public String clientLastName { get; set; }
	public String clientLogin { get; set; }
	public String clientRole { get; set; }
	public String clientEmail { get; set; }

	public String client { get; set; }

	public Candidate__c editCandidate { get; set; }

	public String candidateFirstName { get; set; }
	public String candidateLastName { get; set; }
	public String candidatePosition { get; set; }
	public String candidateHR { get; set; }
	public Decimal candidateSalary { get; set; }
	public Decimal candidateExperience { get; set; }
	public String candidatePhone { get; set; }
	public String candidateEmail { get; set; }
	public String candidateSkype { get; set; }
	public String candidateSourceCandidate { get; set; }
	public String candidateSourceCommunication { get; set; }
	public String candidateStatus { get; set; }
	public String candidateQuestionnaire { get; set; }
	public Date candidateInterviewDate { get; set; }
	public Time candidateInterviewTime { get; set; }
	public String candidateInterviewDateTimeStr { get; set; }
	public Date candidateAnswerPeriod { get; set; }
	public String candidateAnswerPeriodStr { get; set; }
	public String candidateAnswer { get; set; }
	public String candidateDescription { get; set; }

	public String messageError { get; set; }

	public String test { get; set; }

	public CandidateViewPageController() {
		
		this.client = '';
		initClient();

		String idEditCandidate = (String)Cache.Session.get('local.X1234567890.idEditCandidate');
		List<Candidate__c> cnd = (List<Candidate__c>)Database.query('SELECT FirstName__c, LastName__c, ' +
					+ ' Phone__c, Email__c, Skype__c, Status__c, SourceCandidate__c, SourceCommunication__c, ' +
					+ ' Questionnaire__c, InterviewDate__c, InterviewTime__c, AnswerPeriod__c, Answer__c, ' +
					+ ' Experience__c, Position__c, Salary__c, HR__r.LastName__c, HR__r.FirstName__c, Description__c ' +
					+ ' FROM Candidate__c WHERE Id = :idEditCandidate LIMIT 1');
		this.editCandidate = cnd[0];

		this.candidateFirstName = editCandidate.FirstName__c;
		this.candidateLastName = editCandidate.LastName__c;
		this.candidatePhone = editCandidate.Phone__c;
		this.candidateEmail = editCandidate.Email__c;
		this.candidateSkype = editCandidate.Skype__c;
		this.candidateStatus = editCandidate.Status__c;
		this.candidateSourceCandidate = editCandidate.SourceCandidate__c;
		this.candidateSourceCommunication = editCandidate.SourceCommunication__c;
		this.candidateQuestionnaire = editCandidate.Questionnaire__c;
		this.candidateInterviewDate = editCandidate.InterviewDate__c;
		this.candidateInterviewTime = editCandidate.InterviewTime__c;
		if (candidateInterviewDate != null && candidateInterviewTime != null) {
			Datetime dt = DateTime.newInstance(candidateInterviewDate, candidateInterviewTime);
			this.candidateInterviewDateTimeStr = dt.format('dd-MM-yyyy HH:mm a');
		} else {
			this.candidateInterviewDateTimeStr = 'не определенно';
		}
		this.candidateAnswerPeriod = editCandidate.AnswerPeriod__c;
		if (candidateAnswerPeriod != null) {
			Datetime dt = DateTime.newInstance(candidateAnswerPeriod.year(), candidateAnswerPeriod.month(), 
												candidateAnswerPeriod.day());
			this.candidateAnswerPeriodStr = dt.format('dd-MM-yyyy');
		} else {
			this.candidateAnswerPeriodStr = 'не определенно';
		}
		this.candidateAnswer = editCandidate.Answer__c;
		this.candidatePosition = editCandidate.Position__c;
		this.candidateSalary = editCandidate.Salary__c;
		this.candidateExperience = editCandidate.Experience__c;
		this.candidateHR = editCandidate.HR__r.LastName__c + ' ' + editCandidate.HR__r.FirstName__c;
		this.candidateDescription = editCandidate.Description__c;

		//this.test = idEditCandidate + '::' + editCandidate.LastName__c + '::' + editCandidate.FirstName__c;

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

	public void submitComment() {
		
	}

}