document.addEventListener('DOMContentLoaded', () => {
  const itemsPerPage = 10;
  let currentPage = 1;
  let examsData = [];

  const container = document.getElementById('data-container');
  const pageInfo = document.getElementById('page-info');
  const prevButton = document.getElementById('prev-button');
  const nextButton = document.getElementById('next-button');
  const tokenInput = document.getElementById('token');
  const fetchTokenButton = document.getElementById('fetch-token');
  const modal = document.getElementById('modal');
  const modalBody = document.getElementById('modal-body');
  const closeButton = document.querySelector('.close-button');
  const fileInput = document.getElementById('file-input');
  const uploadButton = document.getElementById('upload-button');

  function renderPage(page) {
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

    pageInfo.textContent = `
        Página ${page} de ${Math.ceil(examsData.length / itemsPerPage)}
      `;

    prevButton.disabled = page === 1;
    nextButton.disabled = page === Math.ceil(examsData.length / itemsPerPage);
  }

  function showModal(exam) {
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

  async function fetchData() {
    try {
      const response = await fetch(`${host}/tests`);
      checkServiceAvailability(response);
      if (!response.ok) throw new Error('Service unavailable');

      examsData = await response.json();
      renderPage(currentPage);
    } catch (error) { console.error('Error fetching data:', error); }
  }

  async function fetchExamByToken(token) {
    try {
      const response = await fetch(`${host}/tests/${token}`);
      if (response.status === 404) {
        alert(`Nenhum exame encontrado com o token ${token}`);
        return;
      }

      checkServiceAvailability(response)
      if (!response.ok) throw new Error('Request failed');

      const examData = await response.json();
      showModal(examData);
    } catch (error) { console.error('Error fetching exam data:', error); }
  }

  function checkServiceAvailability(response) {
    if (response.status === 503) {
      alert('A conexão com o servidor falhou');
      return false;
    }
    
    return true;
  }

  async function uploadCSV(file) {
    try {
      const reader = new FileReader();

      reader.onload = async function(event) {
        const csvContent = event.target.result;

        const response = await fetch(`${host}/import`, {
          method: 'POST',
          headers: {
            'Content-Type': 'text/plain',
          },
          body: csvContent,
        });

        if (!response.ok) {
          throw new Error('Upload failed');
        }

        alert('Arquivo CSV enviado com sucesso!');
        fetchData();
      };

      reader.readAsText(file);
    } catch (error) {
      console.error('Error uploading CSV:', error);
      alert('Falha ao enviar o arquivo CSV.');
    }
  }

  prevButton.addEventListener('click', () => {
    if (currentPage > 1) {
      currentPage--;
      renderPage(currentPage);
    }
  });

  nextButton.addEventListener('click', () => {
    if (currentPage < Math.ceil(examsData.length / itemsPerPage)) {
      currentPage++;
      renderPage(currentPage);
    }
  });

  uploadButton.addEventListener('click', () => {
    const file = fileInput.files[0];
    if (file) {
      uploadCSV(file);
    } else {
      alert('Por favor, selecione um arquivo CSV.');
    }
  });

  fetchTokenButton.addEventListener('click', () => {
    if (tokenInput.value) fetchExamByToken(tokenInput.value);
  });

  closeButton.addEventListener('click', () => {
    modal.style.display = "none";
  });

  window.addEventListener('click', (event) => {
    if (event.target == modal) modal.style.display = "none";
  });

  fetchData();
});
