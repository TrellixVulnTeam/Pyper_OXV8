import numpy as np

from pyper.video.video_frame import Frame
from pyper.gui.gui_tracker import GuiTracker


class TemplateTracker(GuiTracker):
    """
    A subclass of GuiTracker
    """

    def _pre_process_frame(self, frame):
        treated_frame = Frame(frame.gray().astype(np.uint8))
        treated_frame = treated_frame.blur(1)
        return treated_frame

    def get_mask(self, frame):
        """
        Get the binary mask (8bits) of the specimen
        from the thresholded difference between frame and the background

        :param frame: The current frame to analyse
        :type frame: video_frame.Frame

        :returns: mask (the binary mask)
        :rtype: video_frame.Frame
        """
        diff = Frame(np.full(frame.shape, 255, dtype=np.uint8) - frame)  # Negative

        diff = diff.astype(np.uint8)
        mask = diff.threshold(self.params.detection_threshold)
        return mask, diff
