let selectedJob = null;

function createJob(icon, title, description, color) {
    // Create job container
    const jobContainer = document.createElement('div');
    jobContainer.classList.add('jobcenter-job');


    jobContainer.addEventListener('click', function(event) {
        selectedJob = title;
    });
    // Create icon element
    const iconElement = document.createElement('i');
    iconElement.classList.add('fa-solid', icon);

    // Create job titles container
    const jobTitlesContainer = document.createElement('div');
    jobTitlesContainer.classList.add('jobcenter-job-titles');

    // Create title element
    const titleElement = document.createElement('span');
    titleElement.classList.add('jobcenter-job-title');
    titleElement.textContent = title;
    if (color) {
        titleElement.style.color = color; // Apply provided color to the title
    }

    // Create description element
    const descriptionElement = document.createElement('span');
    descriptionElement.classList.add('jobcenter-job-subtitle');
    descriptionElement.textContent = description;

    // Append title and description elements to job titles container
    jobTitlesContainer.appendChild(titleElement);
    jobTitlesContainer.appendChild(descriptionElement);

    // Append icon and job titles container to the job container
    jobContainer.appendChild(iconElement);
    jobContainer.appendChild(jobTitlesContainer);

    // Append the job container to jobcenter-jobs
    const jobcenterJobs = document.querySelector('.jobcenter-jobs');
    jobcenterJobs.appendChild(jobContainer);
}

let jobcenter = document.querySelector('.jobcenter');
let gpsButton = document.querySelector('.jobcenter-button');
jobcenter.style.display = 'none'

function deleteAllJobs() {
    let jobcenterJobs = document.querySelector('.jobcenter-jobs');
    while (jobcenterJobs.firstChild) {
        jobcenterJobs.removeChild(jobcenterJobs.firstChild);
    }
}

window.addEventListener("message", function (event1) {
  let event = event1['data'];
  if (event.action == "openJobCenter") {
    deleteAllJobs();
    for(let i = 0; i < event.jobs.length; i++) {
      createJob(event.jobs[i].icon, event.jobs[i].title, event.jobs[i].description, event.jobs[i].color);
      jobcenter.style.display = 'flex';
    }
  }
});

gpsButton.addEventListener('click', function(event) {
    if (jobcenter.style.display == 'flex') {
        jobcenter.style.display = 'none';
        if (selectedJob != null) {
            $.post('http://rpbase/gpsJob', JSON.stringify({
                job: selectedJob
            }));
        }
    }
});

window.addEventListener('keydown', function(event) {
    if(event.key === 'Escape') {
        if (jobcenter.style.display == 'flex') {
            jobcenter.style.display = 'none';
            $.post('http://rpbase/closeJobCenter', JSON.stringify({}));
        }
    }
});
