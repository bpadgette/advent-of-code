(require :uiop)

(defvar dial-start 50)
(defvar dial-state-count 100)
(defvar rotations (uiop:read-file-lines (nth 1 *posix-argv*)))

(let* ((rotation-integers
        (map 'list
            #'(lambda (token)
                (parse-integer
                  (substitute #\0 #\R (substitute #\- #\L token)))) rotations))
       (dial-states-reverse (list dial-start))
       (dial-clicks 0))
  (loop for dial-rotation in rotation-integers do
          (let* ((dial-state (first dial-states-reverse))
                 (target-dial-state (+ dial-rotation (first dial-states-reverse))))
            (loop while (/= dial-state target-dial-state) do
                    (setf dial-state (+ (if (< dial-rotation 0) -1 1) dial-state))
                    (if (= (mod dial-state dial-state-count) 0) (setf dial-clicks (+ dial-clicks 1))))
            (push dial-state dial-states-reverse)))
  (format t "Part 1: ~d~%"
    (count-if #'(lambda (x) (= 0 (mod x dial-state-count))) dial-states-reverse))
  (format t "Part 2: ~d~%" dial-clicks))
