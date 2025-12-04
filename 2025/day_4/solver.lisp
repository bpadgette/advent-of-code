(require :uiop)

(defvar grid (let* ((lines (uiop:read-file-lines (nth 1 *posix-argv*)))
                    (input-matrix (make-array (list (length lines) (length (first lines)))
                                    :initial-contents
                                    (loop for line in lines collect (loop for point across line collect point)))))
               input-matrix))

(defun count-neighbors (neighbor grid-x grid-y)
  (reduce #'+ (loop for x from (- grid-x 1) to (+ grid-x 1) collect
                      (reduce #'+ (loop for y from (- grid-y 1) to (+ grid-y 1) collect
                                          (cond
                                           ((or (< y 0) (> y (- (array-dimension grid 0) 1))) 0)
                                           ((or (< x 0) (> x (- (array-dimension grid 1) 1))) 0)
                                           ((and (= grid-x x) (= grid-y y)) 0)
                                           ((eq neighbor (aref grid y x)) 1)
                                           (t 0)))))))
(defun grid-neighbors ()
  (loop for y from 0 to (- (array-dimension grid 0) 1) collect
          (loop for x from 0 to (- (array-dimension grid 1) 1) collect
                  (count-neighbors #\@ x y))))

;;; DESTRUCTIVE on grid
(defun rolls-accessible (neighbors)
  (reduce #'+ (loop for y from 0 to (- (array-dimension grid 0) 1) collect
                      (reduce #'+ (loop for x from 0 to (- (array-dimension grid 1) 1) collect
                                          (cond
                                           ((and (eq (aref grid y x) #\@) (< (nth x (nth y neighbors)) 4)) (progn (setf (aref grid y x) #\.) 1))
                                           (t 0)))))))

(defun part-2 (total-removed)
  (let ((removed (rolls-accessible (grid-neighbors))))
    (if (zerop removed)
        total-removed
        (part-2 (+ total-removed removed)))))

(let ((part-1 (rolls-accessible (grid-neighbors))))
  (format t "Part 1: ~d~%" part-1)
  (format t "Part 2: ~d~%" (part-2 part-1)))
