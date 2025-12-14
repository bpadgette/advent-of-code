(require :uiop)

(defvar input (map 'list #'(lambda (line) (map 'list #'parse-integer (uiop:split-string line :separator ","))) (uiop:read-file-lines (nth 1 *posix-argv*))))

; continue-until = nil, return all circuits
; continue-until = int, return the last pair joined when circuits at continue-until length (part 2)
(defun solve (continue-until)
  (let* ((n (if (equal "example-input.txt" (nth 1 *posix-argv*)) 10 1000))
         (distances
          (sort (apply #'concatenate
                  'list (loop for (xi yi zi) in input
                              for i from 0
                              collect
                                (loop for (xj yj zj) in input
                                      for j from 0
                                        when (> j i)
                                      collect

                                        (cons (+
                                               ;; no need to take square roots when ranking by distance
                                               (* (- xi xj) (- xi xj))
                                               (* (- yi yj) (- yi yj))
                                               (* (- zi zj) (- zi zj)))
                                              (cons i j)))))
              #'<
            :key 'car))
         (circuits (loop for i below (length input) collect (list i)))
         (i 0))
    (loop while (or continue-until (and (eq continue-until nil) (< i n)))
          do
            (let* ((pair (cdr (car distances)))
                   (j1 (position-if #'(lambda (circuit) (find (car pair) circuit)) circuits))
                   (j2 (position-if #'(lambda (circuit) (find (cdr pair) circuit)) circuits)))
              (setf i (+ i 1))
              (setf distances (cdr distances))
              (if (and j1 j2 (/= j1 j2))
                  (progn
                   (setf (nth j1 circuits) (union (nth j1 circuits) (nth j2 circuits)))
                   (setf circuits (loop for circuit in circuits for k from 0 when (/= k j2) collect circuit))
                   (if (and continue-until (= continue-until (length circuits)))
                       (return-from solve pair))))))
    (sort circuits #'> :key 'length)))

(defun part-1 ()
  (reduce #'* (subseq (solve nil) 0 3) :key 'length))

(defun part-2 ()
  (let ((solution (solve 1)))
    (* (car (nth (car solution) input)) (car (nth (cdr solution) input)))))

(format t "Part 1: ~d~%" (part-1))
(format t "Part 2: ~d~%" (part-2))
