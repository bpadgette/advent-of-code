(require :uiop)

(defvar input
        (map 'list #'(lambda (token) (uiop:split-string token :separator "-"))
          (uiop:split-string (uiop:read-file-string (nth 1 *posix-argv*)) :separator ",")))

(defun get-invalid-id-sum (min-partitions max-partitions)
  (let ((invalid-ids '(0)))
    (map 'list
        #'(lambda (token)
            (let ((i-int (parse-integer (first token))) (stop (parse-integer (nth 1 token))))
              (loop while (<= i-int stop)
                    do
                      (let* ((i-string (write-to-string i-int))
                             (i-length (length i-string)))
                        (loop for i-partitions from min-partitions to max-partitions do
                                (if (and (zerop (mod i-length i-partitions)) (/= (first invalid-ids) i-int) (>= i-length i-partitions))
                                    (let* ((i-subsequence-length (floor i-length i-partitions))
                                           (i-subsequences (loop
                                                          for i-partitions-step from 0 to (- i-partitions 1)
                                                          collect (string (subseq i-string
                                                                                  (* i-partitions-step i-subsequence-length)
                                                                                  (* (+ i-partitions-step 1) i-subsequence-length))))))
                                      (if
                                       (every #'(lambda (x) (string-equal x (first i-subsequences))) i-subsequences)
                                       (push i-int invalid-ids))))))
                      (setf i-int (+ i-int 1)))))
      input)
    (reduce #'+ invalid-ids)))

(format t "Part 1: ~d~%" (get-invalid-id-sum 2 2))
(format t "Part 2: ~d~%" (get-invalid-id-sum 2 20))