(require :uiop)

(defvar input
        (let ((input (make-hash-table :test 'equal)))
          (loop for line in (uiop:read-file-lines (nth 1 *posix-argv*))
                do
                  (let ((key-values (uiop:split-string line :separator ":")))
                    (setf
                      (gethash (car key-values) input)
                      (cdr (uiop:split-string (car (cdr key-values)))))))
          input))

(defvar *mem-cache* (make-hash-table :test 'equal))

(defun depth-first-search (node)
  (cond
   ((string= node "out") 1)
   (t (reduce
          #'(lambda (acc leaf) (+ acc (depth-first-search leaf)))
        (gethash node input)
        :initial-value 0))))

(defun part-1 () (depth-first-search "you"))

(defun depth-first-search-2 (node visited-dac visited-fft)
  (let ((cached (gethash (format nil "~A,~A,~A" node visited-dac visited-fft) *mem-cache*)))
    (if cached
        cached
        (progn (cond
                ((string= node "dac") (setf visited-dac t))
                ((string= node "fft") (setf visited-fft t)))
               (let ((ret
                      (cond
                       ((string= node "out") (if (and visited-dac visited-fft) 1 0))
                       (t (reduce
                              #'(lambda (acc leaf) (+ acc (depth-first-search-2 leaf visited-dac visited-fft)))
                            (gethash node input)
                            :initial-value 0)))))
                 (setf (gethash (format nil "~A,~A,~A" node visited-dac visited-fft) *mem-cache*) ret)
                 ret)))))

(defun part-2 () (depth-first-search-2 "svr" nil nil))

(format t "Part 1: ~d~%" (part-1))
(format t "Part 2: ~d~%" (part-2))
