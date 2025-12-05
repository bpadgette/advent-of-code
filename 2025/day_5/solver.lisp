(require :uiop)

(defvar input
        (let ((fresh-id-ranges (list)) (available-ids (list)))
          (loop for token in (uiop:read-file-lines (nth 1 *posix-argv*)) do
                  (let ((range (map 'list #'parse-integer (uiop:split-string token :separator "-"))))
                    (cond ((= 1 (length range)) (push (first range) available-ids))
                          ((= 2 (length range)) (push range fresh-id-ranges))
                          (t ()))))
          (list fresh-id-ranges available-ids)))

(defun part-1 (ranges available-ids)
  (reduce #'+ (loop for id in available-ids
                    collect (if (some #'(lambda (range) (<= (first range) id (nth 1 range))) ranges) 1 0))))

(defun start (range) (car range))
(defun stop (range) (car (cdr range)))

(defun condense-ranges (ranges)
  (loop for i-range in ranges
        for i from 0
        do
          (loop for j-range in ranges
                for j from 0
                  when
                  (not (eq i j))
                do
                  (cond
                   ;; join range case
                   ((<= (start i-range) (start j-range) (stop i-range) (stop j-range))
                     (return-from
                       condense-ranges
                       (condense-ranges (concatenate 'list
                                          (subseq ranges 0 (min i j))
                                          (list (list (start i-range) (stop j-range))) ;; replace i-range
                                          (subseq ranges (+ 1 (min i j)) (max i j))
                                          ;; omit j-range
                                          (subseq ranges (+ 1 (max i j)))))))
                   ;; omit range case
                   ((<= (start i-range) (start j-range) (stop j-range) (stop i-range))
                     (return-from
                       condense-ranges
                       (condense-ranges (concatenate 'list
                                          (subseq ranges 0 j)
                                          ;; omit j-range
                                          (subseq ranges (+ 1 j)))))))))
  ranges)

(defun part-2 (ranges)
  (reduce #'(lambda (acc range) (+ acc 1 (- (stop range) (start range)))) (condense-ranges ranges) :initial-value 0))

(format t "Part 1: ~d~%" (part-1 (first input) (nth 1 input)))
(format t "Part 2: ~d~%" (part-2 (first input)))
