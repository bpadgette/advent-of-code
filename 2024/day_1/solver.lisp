(require :uiop)

(defvar lists
        (let ((left (list)) (right (list)))
          (loop for line in (uiop:read-file-lines (nth 1 *posix-argv*))
                do (let ((split (uiop:split-string line)))
                     (push (parse-integer (first split)) left)
                     (push (parse-integer (nth 3 split)) right)))
          (list (sort left #'<) (sort right #'<))))

(format t "Part 1: ~d~%"
  (reduce #'+
    (loop for i from 0 to (- (length (first lists)) 1)
          collect
            (abs (- (nth i (first lists)) (nth i (nth 1 lists)))))))

(format t "Part 2: ~d~%"
  (reduce #'+
    (loop for i from 0 to (- (length (first lists)) 1) collect
            (* (nth i (first lists)) (count-if #'(lambda (x) (= x (nth i (first lists)))) (nth 1 lists))))))
