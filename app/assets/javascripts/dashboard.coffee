setupExportModal = ->
  trigger = document.getElementById("export-modal-trigger")
  modal = document.getElementById("export-modal")
  bg = modal.querySelector(".modal-background")
  close = modal.querySelector(".modal-close")
  form = modal.querySelector("form")

  showModal = ->
    modal.style.display = 'block';

  hideModal = ->
    modal.style.display = 'none';

  form.onsubmit = hideModal
  bg.onclick = hideModal
  close.onclick = hideModal
  trigger.onclick = showModal


setupChart = ->
  ctx = document.getElementById("chart")
  data = JSON.parse(ctx.getAttribute("data-values"))
  values = []
  labels = []

  for key in Object.keys(data)
    attrs = data[key]
    values.push(attrs['hours'])
    labels.push(attrs['label'])

  myChart = new Chart ctx, {
    type: 'bar',
    data: {
      labels: labels,
      datasets: [{
        label: '# of Hours',
        data: values,
        backgroundColor: 'rgba(50, 155, 220, 0.56)',
        borderColor: 'rgba(50,115,220,0.78)',
        borderWidth: 1
      }]
    },
    options: {
      legend: {
        display: true,
        position: 'bottom'
      },
      scales: {
        yAxes: [{ticks: {beginAtZero:true}}]
      }
    }
  }


document.addEventListener "js.load", (event) ->
  setupExportModal() if document.getElementById("export-modal-trigger") != null
  setupChart() if document.getElementById("chart") != null
