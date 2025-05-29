;; Outcome Verification Contract
;; Validates restoration success and final outcomes

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u500))
(define-constant ERR_VERIFICATION_EXISTS (err u501))
(define-constant ERR_VERIFICATION_NOT_FOUND (err u502))
(define-constant ERR_INSUFFICIENT_VERIFIERS (err u503))

;; Verification data structures
(define-map outcome-verifications
  { project-id: uint }
  {
    lead-verifier: principal,
    verification-date: uint,
    success-score: uint,
    biodiversity-improvement: uint,
    carbon-sequestration: uint,
    soil-health-improvement: uint,
    water-quality-improvement: uint,
    overall-success: bool,
    certification-level: (string-ascii 20)
  }
)

(define-map verifier-assessments
  { project-id: uint, verifier: principal }
  {
    assessment-date: uint,
    success-rating: uint,
    comments: (string-ascii 300),
    approved: bool
  }
)

(define-map verification-evidence
  { project-id: uint, evidence-id: uint }
  {
    evidence-type: (string-ascii 50),
    description: (string-ascii 200),
    data-hash: (string-ascii 64),
    submitted-by: principal,
    verified: bool
  }
)

(define-map project-evidence-counters
  { project-id: uint }
  { evidence-counter: uint }
)

;; Certification levels
(define-constant CERT_BRONZE "Bronze")
(define-constant CERT_SILVER "Silver")
(define-constant CERT_GOLD "Gold")
(define-constant CERT_PLATINUM "Platinum")

;; Public functions
(define-public (initiate-outcome-verification
  (project-id uint)
  (success-score uint)
  (biodiversity-improvement uint)
  (carbon-sequestration uint)
  (soil-health-improvement uint)
  (water-quality-improvement uint))
  (begin
    (asserts! (is-none (map-get? outcome-verifications { project-id: project-id })) ERR_VERIFICATION_EXISTS)
    (asserts! (<= success-score u100) ERR_UNAUTHORIZED)
    (let ((overall-success (>= success-score u70))
          (cert-level (if (>= success-score u90) CERT_PLATINUM
                         (if (>= success-score u80) CERT_GOLD
                            (if (>= success-score u70) CERT_SILVER CERT_BRONZE)))))
      (map-set outcome-verifications
        { project-id: project-id }
        {
          lead-verifier: tx-sender,
          verification-date: block-height,
          success-score: success-score,
          biodiversity-improvement: biodiversity-improvement,
          carbon-sequestration: carbon-sequestration,
          soil-health-improvement: soil-health-improvement,
          water-quality-improvement: water-quality-improvement,
          overall-success: overall-success,
          certification-level: cert-level
        }
      )
      (ok true)
    )
  )
)

(define-public (submit-verifier-assessment
  (project-id uint)
  (success-rating uint)
  (comments (string-ascii 300)))
  (begin
    (asserts! (<= success-rating u100) ERR_UNAUTHORIZED)
    (map-set verifier-assessments
      { project-id: project-id, verifier: tx-sender }
      {
        assessment-date: block-height,
        success-rating: success-rating,
        comments: comments,
        approved: (>= success-rating u70)
      }
    )
    (ok true)
  )
)

(define-public (submit-verification-evidence
  (project-id uint)
  (evidence-type (string-ascii 50))
  (description (string-ascii 200))
  (data-hash (string-ascii 64)))
  (let ((counters (default-to { evidence-counter: u0 }
                              (map-get? project-evidence-counters { project-id: project-id })))
        (evidence-id (+ (get evidence-counter counters) u1)))
    (map-set verification-evidence
      { project-id: project-id, evidence-id: evidence-id }
      {
        evidence-type: evidence-type,
        description: description,
        data-hash: data-hash,
        submitted-by: tx-sender,
        verified: false
      }
    )
    (map-set project-evidence-counters
      { project-id: project-id }
      { evidence-counter: evidence-id }
    )
    (ok evidence-id)
  )
)

(define-public (verify-evidence (project-id uint) (evidence-id uint))
  (let ((evidence (unwrap! (map-get? verification-evidence { project-id: project-id, evidence-id: evidence-id }) ERR_VERIFICATION_NOT_FOUND)))
    (asserts! (not (is-eq tx-sender (get submitted-by evidence))) ERR_UNAUTHORIZED)
    (map-set verification-evidence
      { project-id: project-id, evidence-id: evidence-id }
      (merge evidence { verified: true })
    )
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-outcome-verification (project-id uint))
  (map-get? outcome-verifications { project-id: project-id })
)

(define-read-only (get-verifier-assessment (project-id uint) (verifier principal))
  (map-get? verifier-assessments { project-id: project-id, verifier: verifier })
)

(define-read-only (get-verification-evidence (project-id uint) (evidence-id uint))
  (map-get? verification-evidence { project-id: project-id, evidence-id: evidence-id })
)

(define-read-only (get-evidence-counter (project-id uint))
  (map-get? project-evidence-counters { project-id: project-id })
)
