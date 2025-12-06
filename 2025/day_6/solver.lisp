(require :uiop)

(defvar input (uiop:read-file-lines (nth 1 *posix-argv*)))

(defvar part-1-matrix (let* ((split (map 'list
                                        #'(lambda (line)
                                            (remove-if #'(lambda (token) (eq 0 (length token)))
                                              (uiop:split-string line :separator " "))) input))
                             (i-max (length split))
                             (j-max (length (car split))))
                        ;; transpose input to put operators after operands in each line
                        (loop for j below j-max
                              collect (loop for i below i-max
                                            collect (nth j (nth i split))))))

(defun part-1 ()
  (reduce
      #'(lambda (acc equation)
          (let ((operator-first (reverse equation)))
            (+ acc (reduce
                       (read-from-string (car operator-first))
                       (map 'list #'parse-integer (cdr operator-first))))))
    part-1-matrix :initial-value 0))

(defvar part-2-list
        (let ((line-length (length (car input))))
          (loop for i downfrom (- line-length 1) to 0
                  ;; join all tokens, RTL
                collect (format nil "~{~A~^~}"
                          (loop for line in input
                                  when (not (string= " " (subseq line i (+ i 1))))
                                collect
                                  (subseq line i (+ i 1)))))))

(defun part-2 ()
  (let ((sum 0) (operator "+") (equation (list)))
    (loop for token in part-2-list
          do (cond
              ((string= "" token)
                (progn
                 (setf sum (+ sum (reduce (read-from-string operator) equation)))
                 (setf equation (list))))
              ((or
                (string= "+" (subseq token (- (length token) 1)))
                (string= "*" (subseq token (- (length token) 1))))
                (progn
                 (setf operator (subseq token (- (length token) 1)))
                 (push (parse-integer (subseq token 0 (- (length token) 1))) equation)))
              (t (push (parse-integer token) equation))))
    (+ sum (reduce (read-from-string operator) equation))))

(format t "Part 1: ~d~%" (part-1))
(format t "Part 2: ~d~%" (part-2))
