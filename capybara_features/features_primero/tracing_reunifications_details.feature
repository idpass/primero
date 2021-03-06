# JIRA PRIMERO-134
# JIRA PRIMERO-232
# JIRA PRIMERO-261
# JIRA PRIMERO-365
# JIRA PRIMERO-429
# JIRA PRIMERO-736

@javascript @primero
Feature: Tracing Reunification Details
  As a Social Worker I want to enter information related to reunification
  so that we can record the status of the child in the reunification process.

  Background:
    Given I am logged in as an admin with username "primero_cp" and password "primero"
    And the following location country exist in the system:
      | placename |
      | Kenya     |
    When I access "cases page"
    And I press the "New Case" button
    And I press the "Tracing" button
    And I click on "Tracing" in form group "Tracing"

  Scenario: As a logged in user, I should access the form section tracing and create reunification details
    And I fill in the 1st "Reunification Details Section" subform with the follow:
      | Name of adult child was reunified with               | Verma Webol               |
      | Relationship of adult to child                       | Father                    |
      | Address                                              | Test Village 2            |
      | Location of adult with whom the child was reunified  | <Choose>Kenya             |
      | Address where the reunification is taking place      | 125 B.Ave                 |
      | Location where the reunifcation is taking place      | <Choose>Kenya             |
      | What type of reunification?                          | <Select> Mass Tracing     |
      | Was the child reunified with the verfified adult?    | <Radio> No                |
      | If not, what was the reason for the change?          | <Select> Change of Mind   |
      | Is there a need for follow up?                       | <Radio> Yes               |
    And I fill in the 2nd "Reunification Details Section" subform with the follow:
      | Name of adult child was reunified with               | Vivian Nelson             |
      | Relationship of adult to child                       | Mother                    |
      | Address                                              | Test Village              |
      | Location of adult with whom the child was reunified  | <Choose>Kenya             |
      | Address where the reunification is taking place      | 123 B.Ave                 |
      | Location where the reunifcation is taking place      | <Choose>Kenya             |
      | What type of reunification?                          | <Select> Mass Tracing     |
      | Date of reunification                                | 30-May-2014               |
      | Was the child reunified with the verfified adult?    | <Radio> Yes               |
      | If not, what was the reason for the change?          | <Select> Not Applicable   |
      | Is there a need for follow up?                       | <Radio> No                |
      | If not, do you recommend that the case be closed?    | <Radio> Yes               |
    And I press "Save"
    Then I should see a success message for new Case
    And I should see in the 1st "Reunification Details Section" subform with the follow:
      | Name of adult child was reunified with               | Verma Webol               |
      | Relationship of adult to child                       | Father                    |
      | Address                                              | Test Village 2            |
      | Location of adult with whom the child was reunified  | Kenya                     |
      | Address where the reunification is taking place      | 125 B.Ave                 |
      | Location where the reunifcation is taking place      | Kenya                     |
      | What type of reunification?                          | Mass Tracing              |
      | Was the child reunified with the verfified adult?    | No                        |
      | If not, what was the reason for the change?          | Change of Mind            |
      | Is there a need for follow up?                       | Yes                       |
    And I should see in the 2nd "Reunification Details Section" subform with the follow:
      | Name of adult child was reunified with               | Vivian Nelson             |
      | Relationship of adult to child                       | Mother                    |
      | Address                                              | Test Village              |
      | Location of adult with whom the child was reunified  | Kenya                     |
      | Address where the reunification is taking place      | 123 B.Ave                 |
      | Location where the reunifcation is taking place      | Kenya                     |
      | What type of reunification?                          | Mass Tracing              |
      | Date of reunification                                | 30-May-2014               |
      | Was the child reunified with the verfified adult?    | Yes                       |
      | If not, what was the reason for the change?          | Not Applicable            |
      | Is there a need for follow up?                       | No                        |
      | If not, do you recommend that the case be closed?    | Yes                       |

  Scenario: As a logged in user, I should access the form section tracing and add/remove reunification details
    And I fill in the 1st "Reunification Details Section" subform with the follow:
      | Name of adult child was reunified with               | Vivian Nelson             |
      | Relationship of adult to child                       | Mother                    |
      | Address                                              | Test Village              |
      | Location of adult with whom the child was reunified  | <Choose>Kenya             |
      | Address where the reunification is taking place      | 123 B.Ave                 |
      | Location where the reunifcation is taking place      | <Choose>Kenya             |
      | What type of reunification?                          | <Select> Mass Tracing     |
      | Date of reunification                                | 30-May-2014               |
      | Was the child reunified with the verfified adult?    | <Radio> Yes               |
      | If not, what was the reason for the change?          | <Select> Not Applicable   |
      | Is there a need for follow up?                       | <Radio> No                |
    And I fill in the 2nd "Reunification Details Section" subform with the follow:
      | Name of adult child was reunified with               | Verma Webol               |
      | Relationship of adult to child                       | Father                    |
      | Address                                              | Test Village 2            |
      | Location of adult with whom the child was reunified  | <Choose>Kenya             |
      | Address where the reunification is taking place      | 125 B.Ave                 |
      | Location where the reunifcation is taking place      | <Choose>Kenya             |
      | What type of reunification?                          | <Select> Mass Tracing     |
      | Date of reunification                                | 31-May-2014               |
      | Was the child reunified with the verfified adult?    | <Radio> No                |
      | If not, what was the reason for the change?          | <Select> Change of Mind   |
      | Is there a need for follow up?                       | <Radio> Yes               |
    And I press "Save"
    Then I should see a success message for new Case
    And I press the "Edit" button
    And I remove the 1st "Reunification Details Section" subform
    And I click OK in the browser popup
    And I fill in the 3rd "Reunification Details Section" subform with the follow:
      | Name of adult child was reunified with               | Marvin Martian            |
      | Relationship of adult to child                       | Father                    |
      | Address                                              | Test Village 3            |
      | Location of adult with whom the child was reunified  | <Choose>Kenya             |
      | Address where the reunification is taking place      | 123 G.Ave                 |
      | Location where the reunifcation is taking place      | <Choose>Kenya             |
      | What type of reunification?                          | <Select> Mass Tracing     |
      | Date of reunification                                | 29-May-2014               |
      | Was the child reunified with the verfified adult?    | <Radio> Yes               |
      | If not, what was the reason for the change?          | <Select> Not Applicable   |
      | Is there a need for follow up?                       | <Radio> No                |
    And I press "Save"
    Then I should not see "Vivian Nelson" on the page
    And I should see "Verma Webol" on the page
    And I should see "Marvin Martian" on the page
