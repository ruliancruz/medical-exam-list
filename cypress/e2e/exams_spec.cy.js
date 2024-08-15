describe('Medical Exams List Page', () => {
  beforeEach(() => {
    cy.fixture('3_test_results').as('threeTestsData');
    cy.fixture('15_test_results').as('fifteenTestsData');
  });

  it('loads the first page of exams', function () {
    cy.intercept('GET', '**/tests', { body: this.threeTestsData })
      .as('getTests');

    cy.visit('/exams');
    cy.wait('@getTests');

    cy.get('.exam-item').eq(0).within(() => {
      cy.contains('IQCZ17');
      cy.contains('Emilly Batista Neto');
      cy.contains('048.973.170-88');
      cy.contains('gerald.crona@ebert-quigley.com');
      cy.contains('2001-03-11');
      cy.contains('Maria Luiza Pires');
      cy.contains('B000BJ20J4');
      cy.contains('PI');
      cy.contains('hemácias');
      cy.contains('45-52');
      cy.contains('97');
      cy.contains('leucócitos');
      cy.contains('9-61');
      cy.contains('89');
      cy.contains('plaquetas');
      cy.contains('11-93');
      cy.contains('97');
    });

    cy.get('.exam-item').eq(1).within(() => {
      cy.contains('0W9I67');
      cy.contains('048.108.026-04');
      cy.contains('B0002IQM66');
    });

    cy.get('.exam-item').eq(2).within(() => {
      cy.contains('T9O6AI');
      cy.contains('066.126.400-90');
      cy.contains('B000B7CDX4');
    });

    cy.get('.exam-item').should('have.length.at.most', 10);
    cy.get('#page-info').should('contain', 'Page 1 of');
  });

  it('navigates to the next page of exams', function () {
    cy.intercept('GET', '**/tests', { body: this.fifteenTestsData })
      .as('getTests');

    cy.visit('/exams');
    cy.wait('@getTests');
    cy.get('#next-button').click();
  
    cy.get('#page-info').should('contain', 'Page 2 of');
  });
  
  it('navigates to the previous page of exams', function () {
    cy.intercept('GET', '**/tests', { body: this.fifteenTestsData })
      .as('getTests');

    cy.visit('/exams');
    cy.wait('@getTests');
    cy.get('#next-button').click();
    cy.get('#prev-button').click();

    cy.get('#page-info').should('contain', 'Page 1 of');
  });

  it('displays a message when no exams are found', function () {
    cy.intercept('GET', '**/tests', { body: [] }).as('getTests');

    cy.visit('/exams');
    cy.wait('@getTests');
  
    cy.contains('Nenhum exame encontrado');
  });
  
  it('disables previous button on the first page', function () {
    cy.intercept('GET', '**/tests', { body: this.threeTestsData })
      .as('getTests');

    cy.visit('/exams');
    cy.wait('@getTests');
  
    cy.get('#prev-button').should('be.disabled');
  });
  
  it('disables next button on the last page', function () {
    cy.intercept(
      'GET', '**/tests',
      { body: this.threeTestsData }
    ).as('getTests');

    cy.visit('/exams');
    cy.wait('@getTests');
  
    cy.get('#next-button').should('be.disabled');
  });
});
