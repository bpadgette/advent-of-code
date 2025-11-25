(require :uiop)

(defvar reports
        (map 'list
            #'(lambda (line) (map 'list #'parse-integer (uiop:split-string line :separator " ")))
          (uiop:read-file-lines (nth 1 *posix-argv*))))

(defvar bad-level-tolerance (parse-integer (nth 2 *posix-argv*)))

(defun report-steps (report)
  (loop for i from 0 to (- (length report) 2) collect
          (- (nth (+ i 1) report) (nth i report))))

(defun remove-nth (n seq)
  (loop for i in
          (remove n (loop for i from 0 to (- (length seq) 1) collect i))
        collect (nth i seq)))

(defun is-safe (report)
  (some
      #'(lambda (derived-report)
          (let ((steps (report-steps derived-report)))
            (and
             (or
              (every #'(lambda (x) (> x 0)) steps)
              (every #'(lambda (x) (< x 0)) steps))
             (every #'(lambda (x) (<= (max (abs x)) 3)) steps) t)))
    (if (= bad-level-tolerance 0)
        (list report)
        (loop for i from 0 to (* bad-level-tolerance (length report)) collect (remove-nth i report)))))

(format t "~d" (count-if #'(lambda (x) x) (map 'list #'is-safe reports)))
