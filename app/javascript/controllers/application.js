import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Stimulusのデバッグモードを設定します (開発中はtrueが便利です)
application.debug = false
window.Stimulus = application

export { application }