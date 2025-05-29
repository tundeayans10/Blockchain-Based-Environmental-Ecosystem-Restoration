;; Baseline Assessment Contract
;; Records pre-restoration environmental conditions

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u200))
(define-constant ERR_ASSESSMENT_EXISTS (err u201))
(define-constant ERR_ASSESSMENT_NOT_FOUND (err u202))

;; Assessment data structure
(define-map baseline-assessments
  { project-id: uint }
  {
    assessor: principal,
    soil-quality-score: uint,
    biodiversity-index: uint,
    water-quality-score: uint,
    vegetation-coverage: uint,
    carbon-stock: uint,
    assessment-date: uint,
    verified: bool,
    verifier: (optional principal)
  }
)

(define-map assessment-details
  { project-id: uint, metric: (string-ascii 50) }
  { value: uint, unit: (string-ascii 20), notes: (string-ascii 200) }
)

;; Public functions
(define-public (record-baseline-assessment
  (project-id uint)
  (soil-quality-score uint)
  (biodiversity-index uint)
  (water-quality-score uint)
  (vegetation-coverage uint)
  (carbon-stock uint))
  (begin
    (asserts! (is-none (map-get? baseline-assessments { project-id: project-id })) ERR_ASSESSMENT_EXISTS)
    (map-set baseline-assessments
      { project-id: project-id }
      {
        assessor: tx-sender,
        soil-quality-score: soil-quality-score,
        biodiversity-index: biodiversity-index,
        water-quality-score: water-quality-score,
        vegetation-coverage: vegetation-coverage,
        carbon-stock: carbon-stock,
        assessment-date: block-height,
        verified: false,
        verifier: none
      }
    )
    (ok true)
  )
)

(define-public (add-assessment-detail
  (project-id uint)
  (metric (string-ascii 50))
  (value uint)
  (unit (string-ascii 20))
  (notes (string-ascii 200)))
  (let ((assessment (unwrap! (map-get? baseline-assessments { project-id: project-id }) ERR_ASSESSMENT_NOT_FOUND)))
    (asserts! (is-eq tx-sender (get assessor assessment)) ERR_UNAUTHORIZED)
    (map-set assessment-details
      { project-id: project-id, metric: metric }
      { value: value, unit: unit, notes: notes }
    )
    (ok true)
  )
)

(define-public (verify-assessment (project-id uint))
  (let ((assessment (unwrap! (map-get? baseline-assessments { project-id: project-id }) ERR_ASSESSMENT_NOT_FOUND)))
    (asserts! (not (is-eq tx-sender (get assessor assessment))) ERR_UNAUTHORIZED)
    (map-set baseline-assessments
      { project-id: project-id }
      (merge assessment { verified: true, verifier: (some tx-sender) })
    )
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-baseline-assessment (project-id uint))
  (map-get? baseline-assessments { project-id: project-id })
)

(define-read-only (get-assessment-detail (project-id uint) (metric (string-ascii 50)))
  (map-get? assessment-details { project-id: project-id, metric: metric })
)
