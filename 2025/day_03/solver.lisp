(require :uiop)

(defvar input
        (map 'list
            #'(lambda (bank)
                (map 'list
                    #'(lambda (battery) (parse-integer (string battery))) bank))
          (uiop:read-file-lines (nth 1 *posix-argv*))))

(defun get-bank-joltage-string
    (base-joltage battery-count bank)
  (let ((bank-length (length bank)))
    (if (<= battery-count 0)
        base-joltage
        (let ((largest-index 0) (largest-value 0))
          (loop for i from 0 to (- bank-length battery-count)
                for battery in bank do
                  (if (> battery largest-value)
                      (progn (setf largest-index i) (setf largest-value battery))))
          (get-bank-joltage-string (format nil "~d~d" base-joltage largest-value) (- battery-count 1) (subseq bank (+ largest-index 1)))))))

(defun get-joltage
    (battery-count)
  (reduce #'(lambda (acc bank) (+ acc (parse-integer (get-bank-joltage-string "" battery-count bank)))) input :initial-value 0))

(format t "Part 1: ~d~%" (get-joltage 2))
(format t "Part 2: ~d~%" (get-joltage 12))
