document.addEventListener('DOMContentLoaded', () => {
  const itemsPerPage = 10;
  let currentPage = 1;
  let examsData = [];

  function renderPage(page) {
    const container = document.getElementById('data-container');
    const start = (page - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    const paginatedData = examsData.slice(start, end);
    
    if (paginatedData.length === 0) {
      container.innerHTML = '<p class="text-center">Nenhum exame encontrado</p>';
    } else {
      container.innerHTML = paginatedData.map(exam => `
        <section class="exam-item mb-2">
          <h2>Token do Exame: ${exam.token}</h2>

          <section class="patient">
            <h3>Dados do Paciente</h3>
            <p><strong>Nome:</strong> ${exam.patient.name}</p>
            <p><strong>CPF:</strong> ${exam.patient.cpf}</p>
            <p><strong>E-mail:</strong> ${exam.patient.email}</p>
            <p><strong>Data de Nascimento:</strong> ${exam.patient.birthdate}</p>
          </section>

          <section class="doctor">
            <h3>Dados do Médico</h3>
            <p><strong>Nome:</strong> ${exam.doctor.name}</p>
            <p><strong>CRM:</strong> ${exam.doctor.crm}-${exam.doctor.crm_state}</p>
          </section>

          <section class="exams">
            <h3>Resultados dos Exames</h3>
            
            <table>
              <thead>
                <tr>
                  <th>Tipo</th>
                  <th>Limites</th>
                  <th>Resultados</th>
                </tr>
              </thead>

              <tbody>
                ${exam.exams.map(test => `
                  <tr>
                    <td>${test.type}</td>
                    <td>${test.limits}</td>
                    <td>${test.result}</td>
                  </tr>
                `).join('')}
              </tbody>
            </table>
          </section>
        </section>
      `).join('');
    }

    document
      .getElementById('page-info')
      .textContent = `
        Página ${page} de ${Math.ceil(examsData.length / itemsPerPage)}
      `;

    document
      .getElementById('prev-button')
      .disabled = page === 1;

    document
      .getElementById('next-button')
      .disabled = page === Math.ceil(examsData.length / itemsPerPage);
  }

  function checkServiceAvailability(response) {
    if (response.status === 503) {
      alert('A conexão com o servidor falhou');
      return false;
    }

    return true;
  }

  async function fetchData() {
    try {
      const response = await fetch(`${host}/tests`);

      checkServiceAvailability(response);
      if (!response.ok) { throw new Error('Service unavailable'); }

      examsData = await response.json();
      renderPage(currentPage);
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  }

  document.getElementById('prev-button').addEventListener('click', () => {
    if (currentPage > 1) {
      currentPage--;
      renderPage(currentPage);
    }
  });

  document.getElementById('next-button').addEventListener('click', () => {
    if (currentPage < Math.ceil(examsData.length / itemsPerPage)) {
      currentPage++;
      renderPage(currentPage);
    }
  });

  async function fetchExamByToken(token) {
    try {
      const response = await fetch(`${host}/tests/${token}`);

      if (response.status === 404) {
        alert(`Nenhum exame encontrado com o token ${token}`);
        return;
      }

      checkServiceAvailability(response)
      if (!response.ok) { throw new Error('Request failed'); }

      const examData = await response.json();
      showModal(examData);
    } catch (error) {
      console.error('Error fetching exam data:', error);
    }
  }

  function showModal(exam) {
    const modal = document.getElementById('modal');
    const modalBody = document.getElementById('modal-body');

    modalBody.innerHTML = `
      <section class="exam-item">
        <h2>Token do Exame: ${exam.token}</h2>
        
        <section class="patient">
          <h3>Dados do Paciente</h3>
          <p><strong>Nome:</strong> ${exam.patient.name}</p>
          <p><strong>CPF:</strong> ${exam.patient.cpf}</p>
          <p><strong>E-mail:</strong> ${exam.patient.email}</p>
          <p><strong>Data de Nascimento:</strong> ${exam.patient.birthdate}</p>
          <p><strong>Endereço:</strong> ${exam.patient.address} - ${exam.patient.city}, ${exam.patient.state}</p>
        </section>

        <section class="doctor">
          <h3>Dados do Médico</h3>
          <p><strong>Nome:</strong> ${exam.doctor.name}</p>
          <p><strong>CRM:</strong> ${exam.doctor.crm}-${exam.doctor.crm_state}</p>
          <p><strong>E-mail:</strong> ${exam.doctor.email}</p>
        </section>

        <section class="exams">
          <h3>Resultados dos Exames</h3>
          
          <table>
            <thead>
              <tr>
                <th>Tipo</th>
                <th>Limites</th>
                <th>Resultados</th>
              </tr>
            </thead>

            <tbody>
              ${exam.exams.map(test => `
                <tr>
                  <td>${test.type}</td>
                  <td>${test.limits}</td>
                  <td>${test.result}</td>
                </tr>
              `).join('')}
            </tbody>
          </table>
        </section>
      </section>
    `;

    modal.style.display = "block";
  }

  document.getElementById('fetch-token').addEventListener('click', () => {
    const token = document.getElementById('token').value;
    if (token) { fetchExamByToken(token); }
  });

  document.querySelector('.close-button').addEventListener('click', () => {
    const modal = document.getElementById('modal');
    modal.style.display = "none";
  });

  window.addEventListener('click', (event) => {
    const modal = document.getElementById('modal');
    if (event.target == modal) { modal.style.display = "none"; }
  });

  fetchData();
});
