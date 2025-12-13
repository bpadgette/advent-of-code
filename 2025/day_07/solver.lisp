(require :uiop)

(defvar input (uiop:read-file-lines (nth 1 *posix-argv*)))

(defun part-1 ()
  (let ((split-count 0)
        (matrix (make-array (list (length input) (length (car input)))
                  :initial-contents input)))
    (loop for i below (array-dimension matrix 0)
          do
            (loop for j below (array-dimension matrix 1)
                  do
                    (let ((point (aref matrix i j))
                          (point-above (if (> i 0) (aref matrix (- i 1) j) nil)))
                      (cond
                       ((and (string= "." point) (or (string= "S" point-above) (string= "|" point-above)))
                         (setf (aref matrix i j) "|"))
                       ((and (string= "^" point) (or (string= "S" point-above) (string= "|" point-above)))
                         (progn
                          (setf split-count (+ 1 split-count))
                          (setf (aref matrix i (- j 1)) "|")
                          (setf (aref matrix i (+ j 1)) "|")))))))
    split-count))


(defun part-2 ()
  (let ((beam-count-at-point (make-array (list (length (car input))))))
    (setf (aref beam-count-at-point (position #\S (car input))) 1)
    (loop for row in (cdr input)
          do
            (loop for point in (coerce row 'list)
                  for j from 0
                    when (and (string= "^" point) (> (aref beam-count-at-point j) 0))
                  do
                    (setf (aref beam-count-at-point (- j 1)) (+ (aref beam-count-at-point j) (aref beam-count-at-point (- j 1))))
                    (setf (aref beam-count-at-point (+ j 1)) (+ (aref beam-count-at-point j) (aref beam-count-at-point (+ j 1))))
                    (setf (aref beam-count-at-point j) 0)))
    (reduce #'+ beam-count-at-point)))

(format t "Part 1: ~d~%" (part-1))
(format t "Part 2: ~d~%" (part-2))
