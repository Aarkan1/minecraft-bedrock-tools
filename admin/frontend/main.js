const statusElement = document.querySelector("#status");

const updateStatus = (data) => {
  statusElement.textContent = data.status;
};

fetch("/api/server/status")
  .then((res) => res.json())
  .then((data) => {
    console.log(data);
    updateStatus(data);
  });
