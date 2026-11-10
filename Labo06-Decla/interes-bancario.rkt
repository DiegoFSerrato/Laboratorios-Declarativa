#lang racket


(define (interes deposito)
  (cond
    [(<= deposito 40000)  (/ (* deposito 3.5) 100)]
    [(<= deposito 260000) (/ (* deposito 4.0) 100)]
    [else                 (/ (* deposito 4.5) 100)]))

;; ---------------------------------------------------------------------
;; Pruebas
;; ---------------------------------------------------------------------

(displayln (interes 15000))    ; 3.5%  ->  525.0
(displayln (interes 40000))    ; 3.5%  ->  1400.0    (límite del primer tramo)
(displayln (interes 40001))    ; 4%    ->  1600.04   (ya cambió de tramo)
(displayln (interes 100000))   ; 4%    ->  4000.0
(displayln (interes 260000))   ; 4%    ->  10400.0   (límite del segundo tramo)
(displayln (interes 260001))   ; 4.5%  ->  11700.045 (ya cambió de tramo)
(displayln (interes 500000))   ; 4.5%  ->  22500.0
