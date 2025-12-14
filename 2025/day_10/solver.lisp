(require :uiop)

(defvar input
        (map 'list #'(lambda (line)
                       (let* ((split (uiop:split-string line :separator " "))
                              (numerics (map
                                            'list
                                            (lambda (button)
                                              (map 'list #'parse-integer
                                                (uiop:split-string
                                                  (subseq button 1 (- (length button) 1)) :separator ",")))
                                          (cdr split))))
                         (list
                          ; bit-mask for lights
                          (reduce
                              #'+
                            (loop for i from 0
                                  for light in
                                    (coerce
                                      (subseq (car split) 1 (- (length (car split)) 1))
                                      'list)
                                    when (equal light #\#)
                                  collect
                                    (ash 1 i))
                            :initial-value 0)
                          ; bit-mask for buttons
                          (loop for button-actions in (subseq numerics 0 (- (length numerics) 1))
                                collect
                                  (reduce
                                      #'+
                                    (loop for light-index in button-actions
                                          collect (ash 1 light-index))
                                    :initial-value 0))
                          ; joltage list
                          (car (subseq (cdr numerics) (- (length numerics) 2))))))
          (uiop:read-file-lines (nth 1 *posix-argv*))))

(defun machine-lights (machine) (car machine))
(defun machine-joltage (machine) (car (cdr (cdr machine))))
(defun machine-buttons (machine) (car (cdr machine)))

;; Approach for toggling lights with logical XOR: https://github.com/mgtezak/Advent_of_Code/blob/master/2025/10/p1.py
(defun toggle-lights (machine)
  (let ((lights (list 0)))
    (loop for presses from 1 do
            (setf lights
              (remove-duplicates
                  (loop for light in lights
                          append
                          (loop for button in (machine-buttons machine)
                                collect
                                  (logxor light button)))))
            (if (find (machine-lights machine) lights)
                (return-from toggle-lights presses)))))

(defun part-1 ()
  (reduce #'+
    (loop for machine in input
          collect
            (toggle-lights machine))))

(defun part-2 () input)

(format t "Part 1: ~d~%" (part-1))
(format t "Part 2: ~d~%" (part-2))
